import SwiftUI

struct StemPlayer: View {
    let stem: AudioStem
    @ObservedObject var audioManager: AudioManager
    @State private var volume: Float
    
    init(stem: AudioStem, audioManager: AudioManager) {
        self.stem = stem
        self.audioManager = audioManager
        _volume = State(initialValue: stem.volume)
    }
    
    var body: some View {
        VStack {
            Text(stem.name)
                .font(.headline)
            
            HStack {
                Image(systemName: stem.isMuted ? "speaker.slash.fill" : "speaker.fill")
                    .foregroundColor(stem.isMuted ? .red : .blue)
                    .onTapGesture {
                        audioManager.toggleMute(for: stem.id.uuidString, isMuted: !stem.isMuted)
                    }
                
                Slider(value: $volume, in: 0...1)
                    .onChange(of: volume) { newValue in
                        audioManager.setVolume(for: stem.id.uuidString, volume: newValue)
                    }
            }
            .padding()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 