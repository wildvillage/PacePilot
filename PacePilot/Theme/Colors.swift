import SwiftUI

extension Color {
    // 主要颜色
    static let primaryBlue = Color(red: 59/255, green: 130/255, blue: 246/255)
    static let primaryGreen = Color(red: 34/255, green: 197/255, blue: 94/255)
    static let primaryOrange = Color(red: 251/255, green: 146/255, blue: 60/255)
    static let primaryRed = Color(red: 239/255, green: 68/255, blue: 68/255)
    static let primaryPurple = Color(red: 147/255, green: 51/255, blue: 234/255)
    
    // 深色主题背景颜色
    static let backgroundPrimary = Color(red: 10/255, green: 10/255, blue: 15/255)
    static let backgroundSecondary = Color(red: 18/255, green: 18/255, blue: 24/255)
    static let backgroundDark = Color(red: 5/255, green: 5/255, blue: 10/255)
    
    // 深色主题文本颜色
    static let textPrimary = Color(red: 248/255, green: 250/255, blue: 252/255)
    static let textSecondary = Color(red: 200/255, green: 210/255, blue: 220/255)
    static let textTertiary = Color(red: 148/255, green: 163/255, blue: 184/255)
    
    // 深色主题卡片和表面
    static let cardBackground = Color(red: 25/255, green: 25/255, blue: 35/255)
    static let cardShadow = Color.black.opacity(0.3)
    
    // 状态颜色
    static let successGreen = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let warningYellow = Color(red: 245/255, green: 158/255, blue: 11/255)
    static let errorRed = Color(red: 220/255, green: 38/255, blue: 127/255)
    
    // 深色主题渐变色
    static let gradientStart = Color(red: 25/255, green: 25/255, blue: 35/255)
    static let gradientEnd = Color(red: 10/255, green: 10/255, blue: 15/255)
    
    // 运动模式专用颜色
    static let runningColor = primaryBlue
    static let walkingColor = primaryGreen
    static let cyclingColor = primaryOrange
}

// 渐变样式
struct AppGradients {
    static let primary = LinearGradient(
        colors: [Color.gradientStart, Color.gradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let success = LinearGradient(
        colors: [Color.successGreen, Color.primaryGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let background = LinearGradient(
        colors: [Color.backgroundPrimary, Color.backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let card = LinearGradient(
        colors: [Color.cardBackground, Color.cardBackground.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}