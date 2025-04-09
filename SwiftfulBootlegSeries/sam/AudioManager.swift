import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    @Published var isPlaying = false
    
    func setupAudio(stems: [AudioStem]) {
        for stem in stems {
            guard let url = Bundle.main.url(forResource: stem.fileName, withExtension: "mp3") else {
                print("Could not find audio file: \(stem.fileName)")
                continue
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.volume = stem.volume
                player.numberOfLoops = -1 // Loop indefinitely
                audioPlayers[stem.id.uuidString] = player
            } catch {
                print("Error creating audio player: \(error)")
            }
        }
        
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    func play() {
        audioPlayers.values.forEach { $0.play() }
        isPlaying = true
    }
    
    func pause() {
        audioPlayers.values.forEach { $0.pause() }
        isPlaying = false
    }
    
    func setVolume(for stemId: String, volume: Float) {
        audioPlayers[stemId]?.volume = volume
    }
    
    func toggleMute(for stemId: String, isMuted: Bool) {
        audioPlayers[stemId]?.volume = isMuted ? 0 : 1
    }
} 