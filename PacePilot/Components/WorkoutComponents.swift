import SwiftUI

// 运动状态指示器
struct WorkoutStatusIndicator: View {
    let isActive: Bool
    let mode: ExerciseMode
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Circle()
                .fill(isActive ? Color.successGreen : Color.gray)
                .frame(width: 12, height: 12)
                .scaleEffect(isActive ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isActive)
            
            Text(isActive ? "\(mode.rawValue)中" : "未开始")
                .font(AppFonts.callout)
                .foregroundColor(isActive ? .successGreen : .textSecondary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            Capsule()
                .fill(isActive ? Color.successGreen.opacity(0.1) : Color.gray.opacity(0.1))
        )
    }
}

// 配速表盘
struct PaceGauge: View {
    let pace: Double
    let targetPace: Double?
    let mode: ExerciseMode
    
    private var normalizedPace: Double {
        if pace == 0 { return 0 }
        // 将配速转换为0-1之间的值，用于显示
        let maxPace: Double = mode == .running ? 10.0 : 20.0 // 最大配速（分钟/公里）
        return min(pace / maxPace, 1.0)
    }
    
    private var color: Color {
        switch mode {
        case .running:
            return .runningColor
        case .walking:
            return .walkingColor
        }
    }
    
    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
            
            // 配速圆环
            Circle()
                .trim(from: 0, to: CGFloat(normalizedPace))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: normalizedPace)
            
            // 目标配速指示器
            if let targetPace = targetPace {
                let targetNormalized = min(targetPace / (mode == .running ? 10.0 : 20.0), 1.0)
                Circle()
                    .trim(from: CGFloat(targetNormalized - 0.01), to: CGFloat(targetNormalized + 0.01))
                    .stroke(Color.warningYellow, lineWidth: 25)
                    .rotationEffect(.degrees(-90))
            }
            
            // 中心内容
            VStack(spacing: AppSpacing.xs) {
                Text("配速")
                    .font(AppFonts.caption1)
                    .foregroundColor(.textSecondary)
                
                Text(formatPace(pace))
                    .font(AppFonts.numberMedium)
                    .foregroundColor(.textPrimary)
                    .minimumScaleFactor(0.7)
                
                Text("分钟/公里")
                    .font(AppFonts.caption2)
                    .foregroundColor(.textTertiary)
            }
        }
        .frame(width: 200, height: 200)
    }
    
    private func formatPace(_ pace: Double) -> String {
        if pace == 0 {
            return "--:--"
        }
        
        let totalSeconds = pace * 60
        let minutes = Int(totalSeconds)
        let seconds = Int((totalSeconds - Double(minutes)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 距离进度条
struct DistanceProgressBar: View {
    let currentDistance: Double // 当前距离（米）
    let targetDistance: Double? // 目标距离（米）
    
    private var progress: Double {
        guard let target = targetDistance, target > 0 else { return 0 }
        return min(currentDistance / target, 1.0)
    }
    
    private var distanceText: String {
        if currentDistance < 1000 {
            return String(format: "%.0f米", currentDistance)
        } else {
            return String(format: "%.2f公里", currentDistance / 1000)
        }
    }
    
    private var targetText: String {
        guard let target = targetDistance else { return "" }
        if target < 1000 {
            return String(format: "目标: %.0f米", target)
        } else {
            return String(format: "目标: %.1f公里", target / 1000)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("距离")
                    .font(AppFonts.headline)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if targetDistance != nil {
                    Text(targetText)
                        .font(AppFonts.caption1)
                        .foregroundColor(.textTertiary)
                }
            }
            
            Text(distanceText)
                .font(AppFonts.numberMedium)
                .foregroundColor(.primaryGreen)
            
            if targetDistance != nil {
                VStack(spacing: AppSpacing.xs) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(AppRadius.sm)
                            
                            Rectangle()
                                .fill(Color.primaryGreen)
                                .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                                .cornerRadius(AppRadius.sm)
                                .animation(.easeInOut(duration: 0.5), value: progress)
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text(String(format: "%.1f%%", progress * 100))
                            .font(AppFonts.caption2)
                            .foregroundColor(.textTertiary)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(Color.cardBackground)
                .cardShadow()
        )
    }
}

// 运动模式选择器
struct ExerciseModeSelector: View {
    @Binding var selectedMode: ExerciseMode
    let isDisabled: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(ExerciseMode.allCases, id: \.self) { mode in
                Button(action: {
                    if !isDisabled {
                        selectedMode = mode
                    }
                }) {
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: mode.icon)
                            .font(.title2)
                            .foregroundColor(selectedMode == mode ? .white : modeColor(mode))
                        
                        Text(mode.rawValue)
                            .font(AppFonts.callout)
                            .foregroundColor(selectedMode == mode ? .white : modeColor(mode))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .fill(selectedMode == mode ? modeColor(mode) : modeColor(mode).opacity(0.1))
                    )
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1.0)
            }
        }
    }
    
    private func modeColor(_ mode: ExerciseMode) -> Color {
        switch mode {
        case .running:
            return .runningColor
        case .walking:
            return .walkingColor
        }
    }
}

// 扩展ExerciseMode以包含图标
extension ExerciseMode {
    var icon: String {
        switch self {
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        }
    }
}