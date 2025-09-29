import SwiftUI

// 临时颜色定义
fileprivate extension Color {
    static let darkTextPrimary = Color(red: 248/255, green: 250/255, blue: 252/255)
    static let darkTextSecondary = Color(red: 200/255, green: 210/255, blue: 220/255)
    static let darkCardBackground = Color(red: 25/255, green: 25/255, blue: 35/255)
    static let darkCardShadow = Color.black.opacity(0.3)
    static let runningBlue = Color(red: 59/255, green: 130/255, blue: 246/255)
    static let walkingGreen = Color(red: 34/255, green: 197/255, blue: 94/255)
    static let warningYellow = Color(red: 245/255, green: 158/255, blue: 11/255)
    static let primaryOrange = Color(red: 251/255, green: 146/255, blue: 60/255)
    static let primaryRed = Color(red: 239/255, green: 68/255, blue: 68/255)
    static let errorRed = Color(red: 220/255, green: 38/255, blue: 127/255)
    static let successGreen = Color(red: 16/255, green: 185/255, blue: 129/255)
}

struct ContentView: View {
    @StateObject private var paceTracker = PaceTracker()
    @StateObject private var audioManager: AudioManager
    
    @State private var showPermissionAlert = false
    @State private var showHistoryView = false
    
    init() {
        let paceTracker = PaceTracker()
        _paceTracker = StateObject(wrappedValue: paceTracker)
        _audioManager = StateObject(wrappedValue: AudioManager(paceTracker: paceTracker))
    }
    
    var body: some View {
        ZStack {
            // 深色主题背景渐变
            LinearGradient(
                colors: [
                    Color(red: 10/255, green: 10/255, blue: 15/255),
                    Color(red: 5/255, green: 5/255, blue: 10/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // 标题区域
                VStack(spacing: 12) {
                    HStack {
                        Text("PacePilot")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color.runningBlue)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        Spacer()
                        
                        // 记录页面入口
                        Button(action: {
                            showHistoryView = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.darkTextSecondary)
                                .padding(8)
                                .background(Color.darkCardBackground)
                                .clipShape(Circle())
                                .shadow(color: Color.darkCardShadow, radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    Text("跑步配速提示助手")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.darkTextSecondary)
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
                
                // 运动模式选择器
                VStack(spacing: 16) {
                    HStack {
                        Text("运动模式")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.darkTextPrimary)
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        ForEach(ExerciseMode.allCases, id: \.self) { mode in
                            Button(action: {
                                if !paceTracker.isTracking {
                                    paceTracker.exerciseMode = mode
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: mode == .running ? "figure.run" : "figure.walk")
                                        .font(.system(size: 16, weight: .medium))
                                    Text(mode.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(
                                    paceTracker.exerciseMode == mode ? .white : 
                                    (mode == .running ? Color.runningBlue : Color.walkingGreen)
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            paceTracker.exerciseMode == mode ? 
                                            (mode == .running ? Color.runningBlue : Color.walkingGreen) :
                                            Color.clear
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    mode == .running ? Color.runningBlue : Color.walkingGreen,
                                                    lineWidth: paceTracker.exerciseMode == mode ? 0 : 1.5
                                                )
                                        )
                                )
                            }
                            .disabled(paceTracker.isTracking)
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // 主要数据展示区域
                VStack(spacing: 24) {
                    // 大型配速卡片
                    VStack(spacing: 0) {
                        // 卡片头部
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("当前配速")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.darkTextSecondary)
                                
                                HStack(alignment: .lastTextBaseline, spacing: 6) {
                                    Text(paceTracker.getPaceString())
                                        .font(.system(size: 42, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.darkTextPrimary)
                                        .minimumScaleFactor(0.7)
                                    
                                    Text("min/km")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color.darkTextSecondary)
                                        .padding(.bottom, 4)
                                }
                            }
                            
                            Spacer()
                            
                            // 速度表指示器
                            ZStack {
                                Circle()
                                    .stroke(Color.darkCardBackground, lineWidth: 8)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .trim(from: 0, to: 0.7) // 模拟进度
                                    .stroke(
                                        Color.runningBlue,
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                                
                                Image(systemName: "speedometer")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(Color.runningBlue)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        
                        // 分割线
                        Rectangle()
                            .fill(Color.darkCardBackground)
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                        
                        // 距离信息
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("移动距离")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.darkTextSecondary)
                                
                                Text(paceTracker.getDistanceString())
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.walkingGreen)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "location.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.walkingGreen)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.darkCardBackground)
                            .shadow(color: Color.darkCardShadow, radius: 12, x: 0, y: 4)
                    )
                    
                    // 时长卡片
                    VStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.primaryOrange)
                        
                        Text(paceTracker.getDurationString())
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color.darkTextPrimary)
                        
                        Text("时长")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.darkTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.darkCardBackground)
                            .shadow(color: Color.darkCardShadow, radius: 8, x: 0, y: 2)
                    )
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // 控制按钮区域
                VStack(spacing: 16) {
                    if paceTracker.isTracking {
                        Button(action: stopTracking) {
                            HStack(spacing: 12) {
                                Image(systemName: "stop.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                Text("停止\(paceTracker.exerciseMode.rawValue)")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.primaryRed,
                                                Color.errorRed
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.primaryRed.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                    } else {
                        Button(action: startTracking) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                Text("开始\(paceTracker.exerciseMode.rawValue)")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: paceTracker.exerciseMode == .running ? [
                                                Color.runningBlue,
                                                Color.runningBlue
                                            ] : [
                                                Color.walkingGreen,
                                                Color.successGreen
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(
                                        color: (paceTracker.exerciseMode == .running ? 
                                               Color.runningBlue : 
                                               Color.walkingGreen).opacity(0.3),
                                        radius: 8, x: 0, y: 4
                                    )
                            )
                        }
                    }
                    
                    // 权限状态提示
                    if paceTracker.authorizationStatus == .denied || paceTracker.authorizationStatus == .restricted {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color.warningYellow)
                            
                            Text("需要位置权限才能追踪\(paceTracker.exerciseMode.rawValue)数据")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.darkTextSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.warningYellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showHistoryView) {
//             HistoryView()
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("需要位置权限"),
                message: Text("请前往设置中允许PacePilot使用您的位置信息来追踪跑步数据"),
                primaryButton: .default(Text("前往设置"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            checkLocationPermission()
        }
    }
    
    private func startTracking() {
        switch paceTracker.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            paceTracker.startTracking()
            audioManager.startPeriodicAnnouncements()
            audioManager.speakImmediateAnnouncement("开始\(paceTracker.exerciseMode.rawValue)追踪")
        case .denied, .restricted:
            showPermissionAlert = true
        case .notDetermined:
            paceTracker.requestLocationPermission()
        @unknown default:
            break
        }
    }
    
    private func stopTracking() {
        paceTracker.stopTracking()
        audioManager.stopPeriodicAnnouncements()
        audioManager.speakImmediateAnnouncement("\(paceTracker.exerciseMode.rawValue)结束")
    }
    
    private func checkLocationPermission() {
        if paceTracker.authorizationStatus == .denied || paceTracker.authorizationStatus == .restricted {
            showPermissionAlert = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
