import SwiftUI

struct CakeView: View {
    @Binding var isCandleLit: Bool
    @State private var flameScale: CGFloat = 1.0
    @State private var flameOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Candle
            VStack(spacing: 0) {
                // Flame
                if isCandleLit {
                    ZStack {
                        // Main flame
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 30))
                            .scaleEffect(flameScale)
                            .offset(x: flameOffset)
                            .animation(
                                Animation
                                    .easeInOut(duration: 0.3)
                                    .repeatForever(autoreverses: true),
                                value: flameScale
                            )
                            .animation(
                                Animation
                                    .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true),
                                value: flameOffset
                            )
                        
                        // Glow effect
                        Circle()
                            .fill(Color.orange.opacity(0.3))
                            .blur(radius: 5)
                            .frame(width: 20, height: 20)
                            .scaleEffect(flameScale * 1.2)
                    }
                    .onAppear {
                        withAnimation {
                            flameScale = 1.2
                            flameOffset = 2
                        }
                    }
                }
                
                // Candle stick
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 10, height: 40)
            }
            .offset(y: -50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.clear) // Make background clear
    }
} 