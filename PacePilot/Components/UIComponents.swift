import SwiftUI

// 数据卡片组件
struct DataCard: View {
    let title: String
    let value: String
    let unit: String?
    let icon: String
    let color: Color
    let backgroundColor: Color?
    
    init(
        title: String,
        value: String,
        unit: String? = nil,
        icon: String,
        color: Color = .primaryBlue,
        backgroundColor: Color? = nil
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.icon = icon
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
                
                Text(title)
                    .font(AppFonts.callout)
                    .foregroundColor(.textSecondary)
            }
            
            HStack(alignment: .lastTextBaseline, spacing: AppSpacing.xs) {
                Text(value)
                    .font(AppFonts.numberMedium)
                    .foregroundColor(.textPrimary)
                
                if let unit = unit {
                    Text(unit)
                        .font(AppFonts.subheadline)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(backgroundColor ?? Color.cardBackground)
                .cardShadow()
        )
    }
}

// 圆形进度条
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let backgroundColor: Color
    let lineWidth: CGFloat
    
    init(
        progress: Double,
        color: Color = .primaryBlue,
        backgroundColor: Color = Color.gray.opacity(0.3),
        lineWidth: CGFloat = 8
    ) {
        self.progress = progress
        self.color = color
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

// 大型数据展示卡片
struct LargeDataCard: View {
    let title: String
    let value: String
    let unit: String?
    let subtitle: String?
    let progress: Double?
    let color: Color
    
    init(
        title: String,
        value: String,
        unit: String? = nil,
        subtitle: String? = nil,
        progress: Double? = nil,
        color: Color = .primaryBlue
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.subtitle = subtitle
        self.progress = progress
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(.textSecondary)
                
                Spacer()
            }
            
            HStack(alignment: .lastTextBaseline, spacing: AppSpacing.sm) {
                Text(value)
                    .font(AppFonts.numberLarge)
                    .foregroundColor(color)
                    .minimumScaleFactor(0.7)
                
                if let unit = unit {
                    Text(unit)
                        .font(AppFonts.title3)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if let progress = progress {
                    CircularProgressView(
                        progress: progress,
                        color: color,
                        lineWidth: 6
                    )
                    .frame(width: 60, height: 60)
                }
            }
            
            if let subtitle = subtitle {
                HStack {
                    Text(subtitle)
                        .font(AppFonts.subheadline)
                        .foregroundColor(.textTertiary)
                    
                    Spacer()
                }
            }
        }
        .padding(AppSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(Color.cardBackground)
                .cardShadow()
        )
    }
}

// 自定义按钮样式
struct PrimaryButtonStyle: ButtonStyle {
    let color: Color
    let isEnabled: Bool
    
    init(color: Color = .primaryBlue, isEnabled: Bool = true) {
        self.color = color
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(isEnabled ? color : Color.gray)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .disabled(!isEnabled)
    }
}

// 次要按钮样式
struct SecondaryButtonStyle: ButtonStyle {
    let color: Color
    
    init(color: Color = .primaryBlue) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.headline)
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}