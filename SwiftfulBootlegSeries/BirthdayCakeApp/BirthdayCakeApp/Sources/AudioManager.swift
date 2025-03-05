import Foundation
import AVFoundation
import AVFAudio

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "birthday_song", withExtension: "mp3") else {
            print("Failed to find sound file")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize audio player: \(error)")
        }
    }
    
    func playMusic() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
} 
