import SwiftUI

struct ContentView: View {
    @State private var degrees: Double = 0.0
    @State private var shouldAnimate: Bool = true // Change to false if you want to start without animation

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 20, endRadius: 600)
                .scaleEffect(1.2)
            RecordPlayerBox()
            
            VStack {
                RecordView(degrees: $degrees, shouldAnimate: $shouldAnimate)
            }
        }
    }
}

#Preview {
    ContentView()
}
