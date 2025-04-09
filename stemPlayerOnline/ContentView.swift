import SwiftUI

struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayerManager()
    @State private var isShowingFilePicker = false
    @State private var selectedFile: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Stem Player")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Player Controls
            HStack(spacing: 30) {
                Button(action: {
                    // Previous track
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                Button(action: {
                    if audioPlayer.isPlaying {
                        audioPlayer.pause()
                    } else {
                        audioPlayer.play()
                    }
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    // Next track
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            
            // Progress Bar
            VStack {
                Slider(value: Binding(
                    get: { audioPlayer.currentTime },
                    set: { audioPlayer.seek(to: $0) }
                ), in: 0...audioPlayer.duration)
                .padding(.horizontal)
                
                HStack {
                    Text(formatTime(audioPlayer.currentTime))
                    Spacer()
                    Text(formatTime(audioPlayer.duration))
                }
                .padding(.horizontal)
            }
            
            // Volume Control
            HStack {
                Image(systemName: "speaker.fill")
                Slider(value: Binding(
                    get: { audioPlayer.volume },
                    set: { audioPlayer.setVolume($0) }
                ), in: 0...1)
                Image(systemName: "speaker.wave.3.fill")
            }
            .padding(.horizontal)
            
            // File Selection Button
            Button(action: {
                isShowingFilePicker = true
            }) {
                Text("Select Audio File")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .fileImporter(
            isPresented: $isShowingFilePicker,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                if let file = files.first {
                    file.startAccessingSecurityScopedResource()
                    selectedFile = file
                    audioPlayer.loadAudio(url: file)
                }
            case .failure(let error):
                print("Error selecting file: \(error)")
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
} 