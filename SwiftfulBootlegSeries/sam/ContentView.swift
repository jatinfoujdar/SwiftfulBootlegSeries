import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var stems = [
        AudioStem(name: "Vocals", fileName: "vocals"),
        AudioStem(name: "Drums", fileName: "drums"),
        AudioStem(name: "Bass", fileName: "bass")
    ]
    
    var body: some View {
        VStack {
            Text("Multi-Stem Player")
                .font(.largeTitle)
                .padding()
            
            ForEach(stems) { stem in
                StemPlayer(stem: stem, audioManager: audioManager)
            }
            
            Button(action: {
                if audioManager.isPlaying {
                    audioManager.pause()
                } else {
                    audioManager.play()
                }
            }) {
                Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .onAppear {
            audioManager.setupAudio(stems: stems)
        }
    }
}

#Preview {
    ContentView()
} 