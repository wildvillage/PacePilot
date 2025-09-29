import Foundation
import CoreLocation
import Combine

// 运动记录模型
struct WorkoutRecord: Identifiable {
    let id = UUID()
    let date: Date
    let duration: TimeInterval
    let distance: Double
    let averagePace: Double
    let mode: ExerciseMode
}

// 添加运动模式枚举
enum ExerciseMode: String, CaseIterable {
    case running = "跑步"
    case walking = "步行"
}

class PaceTracker: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var startTime: Date?
    private var timer: Timer?
    
    @Published var currentPace: Double = 0.0 // 配速（分钟/公里）
    @Published var distance: Double = 0.0 // 总距离（米）
    @Published var duration: TimeInterval = 0.0 // 运动时长（秒）
    @Published var isTracking: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var exerciseMode: ExerciseMode = .running // 默认为跑步模式
    
    // 运动记录
    @Published var workoutRecords: [WorkoutRecord] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        updateLocationSettings()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    // 根据运动模式更新位置设置
    private func updateLocationSettings() {
        switch exerciseMode {
        case .running:
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 10 // 跑步时每10米更新一次
        case .walking:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5 // 步行时每5米更新一次
        }
    }
    
    // 切换运动模式
    func setExerciseMode(_ mode: ExerciseMode) {
        exerciseMode = mode
        if isTracking {
            // 如果正在追踪，则更新位置设置
            updateLocationSettings()
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        isTracking = true
        startTime = Date()
        lastLocation = nil
        distance = 0.0
        currentPace = 0.0
        
        // 更新位置设置
        updateLocationSettings()
        locationManager.startUpdatingLocation()
        
        // 根据运动模式设置不同的播报间隔
        let interval: TimeInterval = exerciseMode == .running ? 30.0 : 60.0
        
        // 启动定时器计算配速和时长
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.duration = Date().timeIntervalSince(startTime)
        }
        
        // 启动配速计算定时器
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.calculateCurrentPace()
        }
        
        // 立即开始计算配速
        calculateCurrentPace()
    }
    
    func stopTracking() {
        isTracking = false
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        
        // 保存运动记录
        if duration > 0 && distance > 0 {
            let record = WorkoutRecord(
                date: Date(),
                duration: duration,
                distance: distance,
                averagePace: currentPace,
                mode: exerciseMode
            )
            workoutRecords.append(record)
        }
        
        // 重置数据
        duration = 0.0
        distance = 0.0
        currentPace = 0.0
    }
    
    private func calculateCurrentPace() {
        guard let startTime = startTime else { return }
        
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(startTime)
        
        // 直接计算配速，无限制
        if distance > 0 && elapsedTime > 0 {
            // 计算配速（分钟/公里）
            let paceInSecondsPerKm = elapsedTime / (distance / 1000)
            currentPace = paceInSecondsPerKm / 60.0
        } else {
            // 初始阶段显示默认值
            currentPace = 0
        }
    }
    
    private func updateDistance(with newLocation: CLLocation) {
        if let lastLocation = lastLocation {
            let distanceDelta = newLocation.distance(from: lastLocation)
            distance += distanceDelta
        }
        lastLocation = newLocation
    }
    
    func getPaceString() -> String {
        if currentPace == 0 {
            return "--:--"
        }
        
        let minutes = Int(currentPace)
        let seconds = Int((currentPace - Double(minutes)) * 60)
        
        return String(format: "%d分%02d秒", minutes, seconds)
    }
    
    func getDistanceString() -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.2f公里", distance / 1000)
        }
    }
    
    func getDurationString() -> String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension PaceTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy > 0 else { return }
        
        updateDistance(with: location)
        
        if isTracking {
            calculateCurrentPace()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("位置权限已授权")
        case .denied, .restricted:
            print("位置权限被拒绝")
        case .notDetermined:
            print("位置权限未确定")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置更新失败: \(error.localizedDescription)")
    }
}