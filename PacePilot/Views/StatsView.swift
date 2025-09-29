import SwiftUI

struct StatsView: View {
    @ObservedObject var paceTracker: PaceTracker
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // 页面标题
                HStack {
                    Text("运动统计")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.lg)
                
                // 当前运动状态
                if paceTracker.isTracking {
                    WorkoutStatusIndicator(
                        isActive: paceTracker.isTracking,
                        mode: paceTracker.exerciseMode
                    )
                    .padding(.horizontal, AppSpacing.lg)
                }
                
                // 主要数据卡片
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.md) {
                    DataCard(
                        title: "当前配速",
                        value: formatPaceValue(paceTracker.currentPace),
                        unit: "min/km",
                        icon: "speedometer",
                        color: .runningColor
                    )
                    
                    DataCard(
                        title: "总距离",
                        value: formatDistanceValue(paceTracker.distance),
                        unit: formatDistanceUnit(paceTracker.distance),
                        icon: "location",
                        color: .primaryGreen
                    )
                    
                    DataCard(
                        title: "运动时长",
                        value: formatDuration(getDuration()),
                        unit: nil,
                        icon: "clock",
                        color: .primaryOrange
                    )
                    
                    DataCard(
                        title: "平均配速",
                        value: formatPaceValue(paceTracker.currentPace),
                        unit: "min/km",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .primaryPurple
                    )
                }
                .padding(.horizontal, AppSpacing.lg)
                
                // 详细统计
                VStack(spacing: AppSpacing.lg) {
                    // 配速趋势
                    StatsTrendCard(
                        title: "配速趋势",
                        icon: "chart.xyaxis.line",
                        color: .runningColor
                    ) {
                        PaceTrendChart(paceTracker: paceTracker)
                    }
                    
                    // 距离分解
                    StatsDetailCard(
                        title: "距离统计",
                        items: [
                            ("本次运动", formatDistance(paceTracker.distance)),
                            ("平均步长", "-- 米"),
                            ("总步数", "-- 步")
                        ]
                    )
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer(minLength: AppSpacing.xxl)
            }
        }
        .background(AppGradients.background)
    }
    
    private func getDuration() -> TimeInterval {
        // 这里应该从PaceTracker获取实际的运动时长
        return 0
    }
    
    private func formatPaceValue(_ pace: Double) -> String {
        if pace == 0 { return "--" }
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
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
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.2f公里", distance / 1000)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// 统计趋势卡片
struct StatsTrendCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            content()
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(Color.cardBackground)
                .cardShadow()
        )
    }
}

// 统计详情卡片
struct StatsDetailCard: View {
    let title: String
    let items: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    HStack {
                        Text(item.0)
                            .font(AppFonts.callout)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text(item.1)
                            .font(AppFonts.callout)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.medium)
                    }
                    
                    if index < items.count - 1 {
                        Divider()
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

// 配速趋势图表（简化版）
struct PaceTrendChart: View {
    @ObservedObject var paceTracker: PaceTracker
    
    var body: some View {
        VStack {
            if paceTracker.currentPace > 0 {
                HStack(spacing: 4) {
                    ForEach(0..<20, id: \.self) { index in
                        Rectangle()
                            .fill(Color.runningColor.opacity(Double.random(in: 0.3...0.8)))
                            .frame(width: 8, height: CGFloat.random(in: 20...60))
                            .cornerRadius(2)
                    }
                }
                .frame(height: 80)
            } else {
                HStack {
                    Text("开始运动后显示配速趋势")
                        .font(AppFonts.callout)
                        .foregroundColor(.textTertiary)
                    
                    Spacer()
                }
                .frame(height: 80)
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(paceTracker: PaceTracker())
    }
}