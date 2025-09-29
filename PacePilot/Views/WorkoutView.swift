import SwiftUI

struct WorkoutView: View {
    @ObservedObject var paceTracker: PaceTracker
    @ObservedObject var audioManager: AudioManager
    
    @State private var showPermissionAlert = false
    @State private var targetDistance: Double = 5000 // 目标距离（米）
    @State private var showTargetSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                AppGradients.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // 页面标题和状态
                        VStack(spacing: AppSpacing.md) {
                            HStack {
                                Text("PacePilot")
                                    .font(AppFonts.largeTitle)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showTargetSettings.toggle()
                                }) {
                                    Image(systemName: "target")
                                        .font(.title2)
                                        .foregroundColor(.primaryBlue)
                                }
                            }
                            
                            WorkoutStatusIndicator(
                                isActive: paceTracker.isTracking,
                                mode: paceTracker.exerciseMode
                            )
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // 运动模式选择器
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            HStack {
                                Text("运动模式")
                                    .font(AppFonts.title3)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                            }
                            
                            ExerciseModeSelector(
                                selectedMode: $paceTracker.exerciseMode,
                                isDisabled: paceTracker.isTracking
                            )
                            .onChange(of: paceTracker.exerciseMode) { _ in
                                if paceTracker.isTracking {
                                    paceTracker.setExerciseMode(paceTracker.exerciseMode)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // 主要数据展示区域
                        if paceTracker.isTracking {
                            // 运动中的详细视图
                            ActiveWorkoutView(
                                paceTracker: paceTracker,
                                targetDistance: targetDistance
                            )
                        } else {
                            // 准备开始的视图
                            ReadyToStartView(
                                paceTracker: paceTracker,
                                targetDistance: targetDistance
                            )
                        }
                        
                        // 控制按钮区域
                        VStack(spacing: AppSpacing.md) {
                            if paceTracker.isTracking {
                                // 运动中的控制按钮
                                HStack(spacing: AppSpacing.md) {
                                    Button(action: pauseWorkout) {
                                        HStack {
                                            Image(systemName: "pause.circle.fill")
                                            Text("暂停")
                                        }
                                    }
                                    .buttonStyle(SecondaryButtonStyle(color: .warningYellow))
                                    
                                    Button(action: stopWorkout) {
                                        HStack {
                                            Image(systemName: "stop.circle.fill")
                                            Text("结束")
                                        }
                                    }
                                    .buttonStyle(PrimaryButtonStyle(color: .errorRed))
                                }
                            } else {
                                // 开始运动按钮
                                Button(action: startWorkout) {
                                    HStack {
                                        Image(systemName: "play.circle.fill")
                                        Text("开始\(paceTracker.exerciseMode.rawValue)")
                                    }
                                }
                                .buttonStyle(PrimaryButtonStyle(
                                    color: modeColor,
                                    isEnabled: canStartWorkout
                                ))
                                
                                if !canStartWorkout {
                                    Button(action: {
                                        showPermissionAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "location.slash")
                                            Text("需要位置权限")
                                        }
                                    }
                                    .buttonStyle(SecondaryButtonStyle(color: .errorRed))
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("需要位置权限"),
                message: Text("请前往设置中允许PacePilot使用您的位置信息来追踪运动数据"),
                primaryButton: .default(Text("前往设置"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showTargetSettings) {
            TargetSettingsView(targetDistance: $targetDistance)
        }
        .onAppear {
            checkLocationPermission()
        }
    }
    
    private var canStartWorkout: Bool {
        return paceTracker.authorizationStatus == .authorizedWhenInUse ||
               paceTracker.authorizationStatus == .authorizedAlways
    }
    
    private var modeColor: Color {
        switch paceTracker.exerciseMode {
        case .running:
            return .runningColor
        case .walking:
            return .walkingColor
        }
    }
    
    private func startWorkout() {
        switch paceTracker.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            paceTracker.startTracking()
            audioManager.startPeriodicAnnouncements()
            audioManager.speakImmediateAnnouncement("开始\(paceTracker.exerciseMode.rawValue)追踪")
        case .denied, .restricted:
            showPermissionAlert = true
        case .notDetermined:
            paceTracker.requestLocationPermission()
        @unknown default:
            break
        }
    }
    
    private func pauseWorkout() {
        // 暂停功能 - 这里可以添加暂停逻辑
        audioManager.speakImmediateAnnouncement("运动已暂停")
    }
    
    private func stopWorkout() {
        paceTracker.stopTracking()
        audioManager.stopPeriodicAnnouncements()
        audioManager.speakImmediateAnnouncement("\(paceTracker.exerciseMode.rawValue)结束")
    }
    
    private func checkLocationPermission() {
        if paceTracker.authorizationStatus == .denied || paceTracker.authorizationStatus == .restricted {
            showPermissionAlert = true
        }
    }
}

// 运动中的活跃视图
struct ActiveWorkoutView: View {
    @ObservedObject var paceTracker: PaceTracker
    let targetDistance: Double
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // 配速表盘
            PaceGauge(
                pace: paceTracker.currentPace,
                targetPace: 6.0, // 目标配速，可以从设置中获取
                mode: paceTracker.exerciseMode
            )
            .padding(.horizontal, AppSpacing.lg)
            
            // 数据卡片网格
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                DataCard(
                    title: "距离",
                    value: formatDistanceValue(paceTracker.distance),
                    unit: formatDistanceUnit(paceTracker.distance),
                    icon: "location",
                    color: .primaryGreen
                )
                
                DataCard(
                    title: "时长",
                    value: "00:00", // 需要从PaceTracker获取实际时长
                    icon: "clock",
                    color: .primaryOrange
                )
                
                DataCard(
                    title: "平均配速",
                    value: formatPaceValue(paceTracker.currentPace),
                    unit: "min/km",
                    icon: "speedometer",
                    color: .primaryPurple
                )
                
                DataCard(
                    title: "卡路里",
                    value: "0", // 需要计算卡路里
                    unit: "卡",
                    icon: "flame",
                    color: .primaryRed
                )
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 进度条
            if targetDistance > 0 {
                DistanceProgressBar(
                    currentDistance: paceTracker.distance,
                    targetDistance: targetDistance
                )
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
    
    private func formatDistanceValue(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f", distance)
        } else {
            return String(format: "%.2f", distance / 1000)
        }
    }
    
    private func formatDistanceUnit(_ distance: Double) -> String {
        return distance < 1000 ? "米" : "公里"
    }
    
    private func formatPaceValue(_ pace: Double) -> String {
        if pace == 0 { return "--:--" }
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 准备开始的视图
struct ReadyToStartView: View {
    @ObservedObject var paceTracker: PaceTracker
    let targetDistance: Double
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // 大型数据展示卡片
            LargeDataCard(
                title: "准备好开始\(paceTracker.exerciseMode.rawValue)了吗？",
                value: "0.00",
                unit: "公里",
                subtitle: targetDistance > 0 ? "目标: \(formatDistance(targetDistance))" : nil,
                color: modeColor
            )
            .padding(.horizontal, AppSpacing.lg)
            
            // 快速统计
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                DataCard(
                    title: "本周运动",
                    value: "3",
                    unit: "次",
                    icon: "calendar",
                    color: .primaryBlue
                )
                
                DataCard(
                    title: "本周距离",
                    value: "12.3",
                    unit: "公里",
                    icon: "location",
                    color: .primaryGreen
                )
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    private var modeColor: Color {
        switch paceTracker.exerciseMode {
        case .running:
            return .runningColor
        case .walking:
            return .walkingColor
        }
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.1f公里", distance / 1000)
        }
    }
}

// 目标设置视图
struct TargetSettingsView: View {
    @Binding var targetDistance: Double
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("设置目标距离")
                        .font(AppFonts.title2)
                        .foregroundColor(.textPrimary)
                    
                    Text("当前目标: \(formatDistance(targetDistance))")
                        .font(AppFonts.headline)
                        .foregroundColor(.primaryBlue)
                    
                    Slider(
                        value: $targetDistance,
                        in: 1000...50000,
                        step: 500
                    ) {
                        Text("目标距离")
                    }
                    .accentColor(.primaryBlue)
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer()
            }
            .navigationTitle("目标设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.1f公里", distance / 1000)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(
            paceTracker: PaceTracker(),
            audioManager: AudioManager(paceTracker: PaceTracker())
        )
    }
}