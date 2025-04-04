import AVFoundation

class SoundManager {
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func loadSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Could not find sound file: \(soundName)")
            return
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.prepareToPlay()
            audioPlayers[soundName] = audioPlayer
        } catch {
            print("Failed to load sound: \(error)")
        }
    }
    
    func playSound(named soundName: String) {
        audioPlayers[soundName]?.play()
    }
    
    func playCollisionSound() {
        playSound(named: "collision")
    }
} 