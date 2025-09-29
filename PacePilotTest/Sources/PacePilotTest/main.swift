import Foundation

// 简化的配速计算逻辑测试
class PaceCalculator {
    private var startTime: Date?
    private var distance: Double = 0.0
    
    func startRun() {
        startTime = Date()
        distance = 0.0
        print("🏃‍♂️ 开始跑步追踪")
    }
    
    func updateDistance(_ newDistance: Double) {
        distance += newDistance
    }
    
    func getCurrentPace() -> String {
        guard let startTime = startTime else { return "--:--" }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        if distance > 0 && elapsedTime > 0 {
            let paceInSecondsPerKm = elapsedTime / (distance / 1000)
            let minutes = Int(paceInSecondsPerKm) / 60
            let seconds = Int(paceInSecondsPerKm) % 60
            return String(format: "%d分%02d秒", minutes, seconds)
        }
        
        return "--:--"
    }
    
    func getDistanceString() -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.2f公里", distance / 1000)
        }
    }
}

// 模拟语音播报
class AudioSimulator {
    func speak(_ text: String) {
        print("🔊 语音播报: \(text)")
    }
}

// 测试主程序
func main() {
    let calculator = PaceCalculator()
    let audio = AudioSimulator()
    
    print("=== PacePilot 功能测试 ===")
    
    // 开始跑步
    calculator.startRun()
    
    // 模拟30秒的跑步数据更新
    for i in 1...6 {
        print("\n--- 第\(i)次播报 (30秒后) ---")
        
        // 模拟跑步距离增加（假设每30秒跑200米）
        calculator.updateDistance(200.0)
        
        let pace = calculator.getCurrentPace()
        let distance = calculator.getDistanceString()
        
        print("当前配速: \(pace) 分钟/公里")
        print("跑步距离: \(distance)")
        
        // 语音播报
        audio.speak("每公里\(pace)，已跑\(distance)")
        
        // 等待30秒（测试时缩短为3秒）
        Thread.sleep(forTimeInterval: 3.0)
    }
    
    print("\n=== 测试完成 ===")
}

main()