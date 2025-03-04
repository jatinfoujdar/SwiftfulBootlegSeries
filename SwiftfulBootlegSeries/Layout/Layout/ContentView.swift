import SwiftUI
import AVKit

struct ContentView: View {
    @State private var frames: [VideoFrame] = initialFrames
    @State private var hoveredFrame: Int? = nil
    @State private var hoverSize: CGFloat = 6
    @State private var gapSize: CGFloat = 4
    @State private var showControls: Bool = false
    @State private var cleanInterface: Bool = true
    @State private var showFrames: Bool = false
    @State private var autoplayMode: AutoplayMode = .all
    
    private let columns: Int = 3
    private let rows: Int = 3
    
    var body: some View {
        VStack(spacing: 16) {
            // Top Controls
            HStack {
                Toggle("Show Frames", isOn: $showFrames)
                    .foregroundColor(.white.opacity(0.7))
                
                Toggle("Autoplay All", isOn: Binding(
                    get: { autoplayMode == .all },
                    set: { autoplayMode = $0 ? .all : .hover }
                ))
                .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            
            // Grid Layout
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gapSize), count: columns), spacing: gapSize) {
                ForEach(frames) { frame in
                    FrameView(
                        frame: binding(for: frame),
                        isHovered: hoveredFrame == frame.id,
                        showFrame: showFrames,
                        autoplayMode: autoplayMode,
                        showControls: showControls
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .onHover { isHovered in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            hoveredFrame = isHovered ? frame.id : nil
                        }
                    }
                }
            }
            .padding()
            
            if !cleanInterface {
                // Bottom Controls
                VStack(spacing: 12) {
                    Toggle("Show Controls", isOn: $showControls)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading) {
                        Text("Hover Size: \(String(format: "%.1f", hoverSize))")
                            .foregroundColor(.white)
                        Slider(value: $hoverSize, in: 4...8, step: 0.1)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Gap Size: \(Int(gapSize))px")
                            .foregroundColor(.white)
                        Slider(value: $gapSize, in: 0...20, step: 1)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(12)
                .padding()
            }
        }
        .background(Color(hex: "141414"))
    }
    
    private func binding(for frame: VideoFrame) -> Binding<VideoFrame> {
        Binding(
            get: { frame },
            set: { newValue in
                if let index = frames.firstIndex(where: { $0.id == frame.id }) {
                    frames[index] = newValue
                }
            }
        )
    }
}


// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
