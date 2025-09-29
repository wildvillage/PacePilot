import SwiftUI
import Foundation

// MARK: - View Extensions
extension View {
    /// 添加条件修饰符
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// 隐藏视图而不影响布局
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }
    
    /// 添加震动反馈
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Color Extensions
extension Color {
    /// 从十六进制字符串创建颜色
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// 获取颜色的十六进制字符串
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

// MARK: - Date Extensions
extension Date {
    /// 格式化为友好的时间显示
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: earliest, to: latest)
        
        if let year = components.year, year >= 1 {
            return "\(year)年前"
        } else if let month = components.month, month >= 1 {
            return "\(month)个月前"
        } else if let week = components.weekOfYear, week >= 1 {
            return "\(week)周前"
        } else if let day = components.day, day >= 1 {
            return "\(day)天前"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)小时前"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)分钟前"
        } else {
            return "刚刚"
        }
    }
    
    /// 格式化为运动时间显示
    func workoutTimeDisplay() -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "今天 HH:mm"
        } else if Calendar.current.isDateInYesterday(self) {
            formatter.dateFormat = "昨天 HH:mm"
        } else {
            formatter.dateFormat = "MM月dd日 HH:mm"
        }
        return formatter.string(from: self)
    }
}

// MARK: - Double Extensions
extension Double {
    /// 格式化配速显示
    func toPaceString() -> String {
        if self == 0 {
            return "--:--"
        }
        
        let totalSeconds = self * 60
        let minutes = Int(totalSeconds)
        let seconds = Int((totalSeconds - Double(minutes)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// 格式化距离显示
    func toDistanceString() -> String {
        if self < 1000 {
            return String(format: "%.0f米", self)
        } else {
            return String(format: "%.2f公里", self / 1000)
        }
    }
    
    /// 格式化时长显示
    func toDurationString() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - String Extensions
extension String {
    /// 本地化字符串
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// 首字母大写
    var capitalizedFirst: String {
        return prefix(1).capitalized + dropFirst()
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    private enum Keys {
        static let workoutHistory = "workoutHistory"
        static let userSettings = "userSettings"
        static let targetDistance = "targetDistance"
        static let preferredUnit = "preferredUnit"
        static let enableVoiceAnnouncements = "enableVoiceAnnouncements"
        static let announcementInterval = "announcementInterval"
    }
    
    /// 保存运动记录
    func saveWorkoutRecord(_ record: WorkoutRecord) {
        var records = getWorkoutHistory()
        records.append(record)
        
        if let encoded = try? JSONEncoder().encode(records) {
            set(encoded, forKey: Keys.workoutHistory)
        }
    }
    
    /// 获取运动历史
    func getWorkoutHistory() -> [WorkoutRecord] {
        guard let data = data(forKey: Keys.workoutHistory),
              let records = try? JSONDecoder().decode([WorkoutRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    /// 清除运动历史
    func clearWorkoutHistory() {
        removeObject(forKey: Keys.workoutHistory)
    }
    
    /// 目标距离
    var targetDistance: Double {
        get { double(forKey: Keys.targetDistance) == 0 ? 5000 : double(forKey: Keys.targetDistance) }
        set { set(newValue, forKey: Keys.targetDistance) }
    }
    
    /// 首选单位
    var preferredUnit: String {
        get { string(forKey: Keys.preferredUnit) ?? "metric" }
        set { set(newValue, forKey: Keys.preferredUnit) }
    }
    
    /// 启用语音播报
    var enableVoiceAnnouncements: Bool {
        get { object(forKey: Keys.enableVoiceAnnouncements) as? Bool ?? true }
        set { set(newValue, forKey: Keys.enableVoiceAnnouncements) }
    }
    
    /// 播报间隔
    var announcementInterval: Double {
        get { double(forKey: Keys.announcementInterval) == 0 ? 30 : double(forKey: Keys.announcementInterval) }
        set { set(newValue, forKey: Keys.announcementInterval) }
    }
}

// MARK: - WorkoutRecord Codable
extension WorkoutRecord: Codable {
    enum CodingKeys: String, CodingKey {
        case id, date, mode, distance, duration, averagePace, calories
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(mode, forKey: .mode)
        try container.encode(distance, forKey: .distance)
        try container.encode(duration, forKey: .duration)
        try container.encode(averagePace, forKey: .averagePace)
        try container.encode(calories, forKey: .calories)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        mode = try container.decode(ExerciseMode.self, forKey: .mode)
        distance = try container.decode(Double.self, forKey: .distance)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        averagePace = try container.decode(Double.self, forKey: .averagePace)
        calories = try container.decode(Int.self, forKey: .calories)
    }
}

// MARK: - ExerciseMode Codable
extension ExerciseMode: Codable {}

// MARK: - Animation Extensions
extension Animation {
    static let smooth = Animation.easeInOut(duration: 0.3)
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)
    static let bounce = Animation.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)
}