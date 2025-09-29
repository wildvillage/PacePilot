import Foundation
import AVFoundation

class AudioManager: NSObject, ObservableObject {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var paceTracker: PaceTracker?
    private var announcementTimer: Timer?
    
    @Published var isSpeaking = false
    
    init(paceTracker: PaceTracker) {
        super.init()
        self.paceTracker = paceTracker
        configureSpeechSynthesizer()
    }
    
    private func configureSpeechSynthesizer() {
        // 配置语音合成器
        speechSynthesizer.delegate = self
    }
    
    func startPeriodicAnnouncements() {
        // 根据运动模式设置不同的播报间隔
        let interval: TimeInterval = paceTracker?.exerciseMode == .running ? 30.0 : 60.0
        
        // 启动定时器播报配速
        announcementTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.announceCurrentPace()
        }
        
        // 立即播报一次
        announceCurrentPace()
    }
    
    func stopPeriodicAnnouncements() {
        announcementTimer?.invalidate()
        announcementTimer = nil
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    private func announceCurrentPace() {
        guard let paceTracker = paceTracker, paceTracker.isTracking else { return }
        
        let paceString = paceTracker.getPaceString()
        let distanceString = paceTracker.getDistanceString()
        
        let actionText = paceTracker.exerciseMode == .walking ? "已走" : "已跑"
        let announcementText = "每公里\(paceString)，\(actionText)\(distanceString)"
        
        speak(text: announcementText)
    }
    
    private func speak(text: String) {
        guard !speechSynthesizer.isSpeaking else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5 // 语速稍慢
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        // 配置音频会话，确保与其他音频共存
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers, .duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话配置失败: \(error)")
        }
        
        speechSynthesizer.speak(utterance)
    }
    
    func speakImmediateAnnouncement(_ text: String) {
        speak(text: text)
    }
}

extension AudioManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        
        // 降低其他音频音量（ducking）
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话激活失败: \(error)")
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        
        // 恢复其他音频音量
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话停用失败: \(error)")
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        
        // 恢复其他音频音量
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话停用失败: \(error)")
        }
    }
}