import SwiftUI

struct SettingsView: View {
    @AppStorage("targetDistance") private var targetDistance: Double = 5000 // 默认5公里
    @AppStorage("enableVoiceAnnouncements") private var enableVoiceAnnouncements: Bool = true
    @AppStorage("announcementInterval") private var announcementInterval: Double = 30 // 秒
    @AppStorage("preferredUnit") private var preferredUnit: String = "metric"
    
    var body: some View {
        NavigationView {
            List {
                // 运动设置
                Section("运动设置") {
                    // 目标距离设置
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.primaryBlue)
                                .frame(width: 24)
                            
                            Text("目标距离")
                                .font(AppFonts.callout)
                            
                            Spacer()
                            
                            Text(formatDistance(targetDistance))
                                .font(AppFonts.callout)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Slider(
                            value: $targetDistance,
                            in: 1000...50000,
                            step: 500
                        ) {
                            Text("目标距离")
                        }
                        .accentColor(.primaryBlue)
                    }
                    .padding(.vertical, AppSpacing.sm)
                    
                    // 单位设置
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundColor(.primaryGreen)
                            .frame(width: 24)
                        
                        Text("距离单位")
                            .font(AppFonts.callout)
                        
                        Spacer()
                        
                        Picker("距离单位", selection: $preferredUnit) {
                            Text("公制 (km)").tag("metric")
                            Text("英制 (mi)").tag("imperial")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // 语音设置
                Section("语音播报") {
                    // 启用语音播报
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.primaryOrange)
                            .frame(width: 24)
                        
                        Text("启用语音播报")
                            .font(AppFonts.callout)
                        
                        Spacer()
                        
                        Toggle("", isOn: $enableVoiceAnnouncements)
                            .toggleStyle(SwitchToggleStyle(tint: .primaryOrange))
                    }
                    
                    // 播报间隔
                    if enableVoiceAnnouncements {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.primaryPurple)
                                    .frame(width: 24)
                                
                                Text("播报间隔")
                                    .font(AppFonts.callout)
                                
                                Spacer()
                                
                                Text("\(Int(announcementInterval))秒")
                                    .font(AppFonts.callout)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Slider(
                                value: $announcementInterval,
                                in: 15...300,
                                step: 15
                            ) {
                                Text("播报间隔")
                            }
                            .accentColor(.primaryPurple)
                        }
                        .padding(.vertical, AppSpacing.sm)
                    }
                }
                
                // 权限设置
                Section("权限管理") {
                    SettingsRow(
                        icon: "location",
                        iconColor: .primaryRed,
                        title: "位置权限",
                        subtitle: "用于追踪运动数据",
                        action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    SettingsRow(
                        icon: "speaker.2",
                        iconColor: .warningYellow,
                        title: "音频权限",
                        subtitle: "用于语音播报功能",
                        action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
                
                // 应用信息
                Section("关于") {
                    SettingsInfoRow(title: "版本", value: "1.0.0")
                    SettingsInfoRow(title: "开发者", value: "PacePilot Team")
                    
                    SettingsRow(
                        icon: "star",
                        iconColor: .warningYellow,
                        title: "评价应用",
                        subtitle: "在App Store中评价我们"
                    ) {
                        // 这里可以添加跳转到App Store评价的逻辑
                    }
                    
                    SettingsRow(
                        icon: "envelope",
                        iconColor: .primaryBlue,
                        title: "联系我们",
                        subtitle: "反馈问题或建议"
                    ) {
                        // 这里可以添加邮件联系的逻辑
                    }
                }
                
                // 数据管理
                Section("数据管理") {
                    SettingsRow(
                        icon: "trash",
                        iconColor: .errorRed,
                        title: "清除运动数据",
                        subtitle: "删除所有历史记录",
                        isDestructive: true
                    ) {
                        // 这里可以添加清除数据的逻辑
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if preferredUnit == "metric" {
            if distance < 1000 {
                return String(format: "%.0f米", distance)
            } else {
                return String(format: "%.1f公里", distance / 1000)
            }
        } else {
            let miles = distance * 0.000621371
            return String(format: "%.2f英里", miles)
        }
    }
}

// 设置行组件
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let isDestructive: Bool
    let action: (() -> Void)?
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String? = nil,
        isDestructive: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .errorRed : iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.callout)
                        .foregroundColor(isDestructive ? .errorRed : .textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppFonts.caption1)
                            .foregroundColor(.textTertiary)
                    }
                }
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textTertiary)
                        .font(.callout)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 设置信息行组件
struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.callout)
                .foregroundColor(.textSecondary)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}