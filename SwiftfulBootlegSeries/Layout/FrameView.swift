import SwiftUI
import AVKit

struct FrameView: View {
    @Binding var frame: VideoFrame
    let isHovered: Bool
    let showFrame: Bool
    let autoplayMode: AutoplayMode
    let showControls: Bool
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video Player
                VideoPlayerView(player: player)
                    .frame(
                        width: showFrame ? geometry.size.width * frame.borderSize / 100 : geometry.size.width,
                        height: showFrame ? geometry.size.height * frame.borderSize / 100 : geometry.size.height
                    )
                    .scaleEffect(frame.mediaSize)
                    .clipped()
                
                if showFrame {
                    // Frame Border
                    FrameBorderView(
                        corner: frame.corner,
                        edgeHorizontal: frame.edgeHorizontal,
                        edgeVertical: frame.edgeVertical,
                        borderThickness: frame.borderThickness
                    )
                }
                
                // Controls Overlay
                if showControls {
                    VStack {
                        Spacer()
                        ControlsOverlay(frame: $frame)
                    }
                }
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onChange(of: isHovered) { newValue in
            handleHoverStateChange(newValue)
        }
        .onChange(of: autoplayMode) { newValue in
            handleAutoplayModeChange(newValue)
        }
    }
    
    private func setupPlayer() {
        player = AVPlayer(url: frame.video)
        player?.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            player?.seek(to: .zero)
            player?.play()
        }
        
        if autoplayMode == .all {
            player?.play()
            isPlaying = true
        }
    }
    
    private func handleHoverStateChange(_ isHovered: Bool) {
        if autoplayMode == .hover {
            if isHovered {
                player?.play()
                isPlaying = true
            } else {
                player?.pause()
                isPlaying = false
            }
        }
    }
    
    private func handleAutoplayModeChange(_ mode: AutoplayMode) {
        switch mode {
        case .all:
            player?.play()
            isPlaying = true
        case .hover:
            if !isHovered {
                player?.pause()
                isPlaying = false
            }
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

struct FrameBorderView: View {
    let corner: String
    let edgeHorizontal: String
    let edgeVertical: String
    let borderThickness: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Corners
                Group {
                    AsyncImage(url: URL(string: corner)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64, height: 64)
                    .position(x: 32, y: 32)
                    
                    AsyncImage(url: URL(string: corner)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64, height: 64)
                    .scaleEffect(x: -1, y: 1)
                    .position(x: geometry.size.width - 32, y: 32)
                    
                    AsyncImage(url: URL(string: corner)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64, height: 64)
                    .scaleEffect(x: 1, y: -1)
                    .position(x: 32, y: geometry.size.height - 32)
                    
                    AsyncImage(url: URL(string: corner)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64, height: 64)
                    .scaleEffect(x: -1, y: -1)
                    .position(x: geometry.size.width - 32, y: geometry.size.height - 32)
                }
                
                // Edges
                Group {
                    // Top
                    AsyncImage(url: URL(string: edgeHorizontal)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(height: 64)
                    .position(x: geometry.size.width / 2, y: 32)
                    
                    // Bottom
                    AsyncImage(url: URL(string: edgeHorizontal)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(height: 64)
                    .scaleEffect(x: 1, y: -1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 32)
                    
                    // Left
                    AsyncImage(url: URL(string: edgeVertical)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64)
                    .position(x: 32, y: geometry.size.height / 2)
                    
                    // Right
                    AsyncImage(url: URL(string: edgeVertical)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 64)
                    .scaleEffect(x: -1, y: 1)
                    .position(x: geometry.size.width - 32, y: geometry.size.height / 2)
                }
            }
            .padding(borderThickness)
        }
    }
}

struct ControlsOverlay: View {
    @Binding var frame: VideoFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Media Size: \(String(format: "%.2f", frame.mediaSize))")
                .foregroundColor(.white)
            Slider(value: $frame.mediaSize, in: 0.5...3, step: 0.01)
            
            Text("Border Thickness: \(Int(frame.borderThickness))px")
                .foregroundColor(.white)
            Slider(value: $frame.borderThickness, in: 0...20, step: 1)
            
            Text("Border Size: \(Int(frame.borderSize))%")
                .foregroundColor(.white)
            Slider(value: $frame.borderSize, in: 50...100, step: 1)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
        .padding()
    }
} 