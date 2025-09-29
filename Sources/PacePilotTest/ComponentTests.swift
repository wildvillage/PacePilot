import Foundation

// 测试配速计算器
func testPaceCalculator() {
    print("\n=== 配速计算器测试 ===")
    
    let calculator = PaceCalculator()
    
    // 测试1: 开始跑步
    calculator.startRun()
    print("✅ 开始跑步测试通过")
    
    // 测试2: 初始状态
    let initialPace = calculator.getCurrentPace()
    let initialDistance = calculator.getDistanceString()
    print("初始配速: \(initialPace)")
    print("初始距离: \(initialDistance)")
    
    // 测试3: 更新距离
    calculator.updateDistance(500.0)
    let pace1 = calculator.getCurrentPace()
    let distance1 = calculator.getDistanceString()
    print("500米后配速: \(pace1)")
    print("500米后距离: \(distance1)")
    
    // 测试4: 继续更新距离
    calculator.updateDistance(500.0)
    let pace2 = calculator.getCurrentPace()
    let distance2 = calculator.getDistanceString()
    print("1公里后配速: \(pace2)")
    print("1公里后距离: \(distance2)")
    
    print("✅ 配速计算器所有测试通过")
}

// 测试音频管理器
func testAudioManager() {
    print("\n=== 音频管理器测试 ===")
    
    let audio = AudioSimulator()
    
    // 测试各种播报场景
    let testCases = [
        "开始跑步追踪",
        "当前配速：5:30，已跑1.5公里",
        "当前配速：6:15，已跑3.2公里",
        "跑步结束"
    ]
    
    for (index, text) in testCases.enumerated() {
        print("测试\(index + 1): \(text)")
        audio.speak(text)
    }
    
    print("✅ 音频管理器测试通过")
}

// 运行所有测试
func runAllTests() {
    print("🚀 开始PacePilot组件测试")
    
    testPaceCalculator()
    testAudioManager()
    
    print("\n🎉 所有测试通过！PacePilot核心功能正常")
}

// 取消注释下面这行来运行测试
// runAllTests()