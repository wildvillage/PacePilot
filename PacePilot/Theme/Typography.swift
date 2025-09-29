import SwiftUI

// 自定义字体样式
struct AppFonts {
    // 标题字体
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    
    // 正文字体
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // 数字显示字体
    static let numberLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    static let numberMedium = Font.system(size: 32, weight: .bold, design: .rounded)
    static let numberSmall = Font.system(size: 24, weight: .semibold, design: .rounded)
}

// 间距系统
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// 圆角半径
struct AppRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let circle: CGFloat = 1000
}

// 阴影样式
struct AppShadows {
    static let light = Shadow(
        color: Color.cardShadow,
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let medium = Shadow(
        color: Color.cardShadow,
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let heavy = Shadow(
        color: Color.cardShadow,
        radius: 16,
        x: 0,
        y: 8
    )
}

// 阴影扩展
extension View {
    func cardShadow() -> some View {
        self.shadow(
            color: Color.cardShadow,
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    func lightShadow() -> some View {
        self.shadow(
            color: Color.cardShadow,
            radius: 4,
            x: 0,
            y: 2
        )
    }
}