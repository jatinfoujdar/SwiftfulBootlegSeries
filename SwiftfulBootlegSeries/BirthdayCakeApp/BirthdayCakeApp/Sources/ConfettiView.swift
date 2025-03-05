import SwiftUI

struct ConfettiView: View {
    @State private var isAnimating = false
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<200) { index in
                Circle()
                    .fill(colors[index % colors.count])
                    .frame(width: 8, height: 200)
                    .position(
                        x: randomPosition(in: geometry.size.width),
                        y: isAnimating ? geometry.size.height + 1000 : -100
                    )
                    .animation(
                        Animation.linear(duration: 4)
                            .repeatCount(3, autoreverses: false)
                            .delay(Double.random(in: 0...1)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
    
    private func randomPosition(in width: CGFloat) -> CGFloat {
        CGFloat.random(in: 0...width)
    }
} 
