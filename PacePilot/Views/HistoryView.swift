import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var paceTracker = PaceTracker()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 统计概览
                HStack(spacing: 16) {
                    HistoryStatCard(
                        title: "总运动次数",
                        value: "\(paceTracker.workoutRecords.count)",
                        icon: "figure.run",
                        color: .runningBlue
                    )
                    
                    HistoryStatCard(
                        title: "总距离",
                        value: formatTotalDistance(),
                        icon: "location",
                        color: .walkingGreen
                    )
                    
                    HistoryStatCard(
                        title: "总时长",
                        value: formatTotalDuration(),
                        icon: "clock",
                        color: .primaryOrange
                    )
                }
                .padding(.horizontal, 24)
                
                // 运动记录列表
                if paceTracker.workoutRecords.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(paceTracker.workoutRecords) { record in
                            WorkoutRecordRow(record: record)
                                .listRowInsets(EdgeInsets(
                                    top: 8,
                                    leading: 16,
                                    bottom: 8,
                                    trailing: 16
                                ))
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("运动历史")
            .navigationBarTitleDisplayMode(.large)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 10/255, green: 10/255, blue: 15/255),
                        Color(red: 5/255, green: 5/255, blue: 10/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.runningBlue)
                }
            }
        }
    }
    
    
    private func deleteWorkout(at offsets: IndexSet) {
        paceTracker.workoutRecords.remove(atOffsets: offsets)
    }
    
    private func formatTotalDistance() -> String {
        let total = paceTracker.workoutRecords.reduce(0) { $0 + $1.distance }
        if total < 1000 {
            return String(format: "%.0f米", total)
        } else {
            return String(format: "%.1f公里", total / 1000)
        }
    }
    
    private func formatTotalDuration() -> String {
        let total = paceTracker.workoutRecords.reduce(0) { $0 + $1.duration }
        let hours = Int(total) / 3600
        let minutes = Int(total) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)小时\(minutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
    
    
}


// 历史统计卡片
struct HistoryStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.darkTextPrimary)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.darkTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCardBackground)
                .shadow(color: Color.darkCardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

// 运动记录行
struct WorkoutRecordRow: View {
    let record: WorkoutRecord
    
    var body: some View {
        HStack(spacing: 16) {
            // 运动类型图标
            Image(systemName: record.mode == .running ? "figure.run" : "figure.walk")
                .font(.title2)
                .foregroundColor(modeColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(modeColor.opacity(0.1))
                )
            
            // 运动信息
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(record.mode.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.darkTextPrimary)
                    
                    Spacer()
                    
                    Text(formatDate(record.date))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.darkTextSecondary)
                }
                
                HStack {
                    Label(formatDistance(record.distance), systemImage: "location")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.darkTextSecondary)
                    
                    Spacer()
                    
                    Label(formatDuration(record.duration), systemImage: "clock")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.darkTextSecondary)
                }
                
                HStack {
                    Label(formatPace(record.averagePace), systemImage: "speedometer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.darkTextSecondary)
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCardBackground)
                .shadow(color: Color.darkCardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private var modeColor: Color {
        switch record.mode {
        case .running:
            return .runningBlue
        case .walking:
            return .walkingGreen
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        return formatter.string(from: date)
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f米", distance)
        } else {
            return String(format: "%.2f公里", distance / 1000)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formatPace(_ pace: Double) -> String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 空历史记录视图
struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 80))
                .foregroundColor(Color.darkTextSecondary)
            
            VStack(spacing: 8) {
                Text("还没有运动记录")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.darkTextPrimary)
                
                Text("开始你的第一次运动吧！")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.darkTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

