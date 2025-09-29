import SwiftUI

struct MainTabView: View {
    @StateObject private var paceTracker = PaceTracker()
    @StateObject private var audioManager: AudioManager
    
    init() {
        let paceTracker = PaceTracker()
        _paceTracker = StateObject(wrappedValue: paceTracker)
        _audioManager = StateObject(wrappedValue: AudioManager(paceTracker: paceTracker))
        
        // 自定义TabView外观
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.separator
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // 主运动页面
            WorkoutView(paceTracker: paceTracker, audioManager: audioManager)
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("运动")
                }
            
            // 统计页面
            StatsView(paceTracker: paceTracker)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("统计")
                }
            
            // 历史记录页面
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("历史")
                }
            
            // 设置页面
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }
        }
        .accentColor(.primaryBlue)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}