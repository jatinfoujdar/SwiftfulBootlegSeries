import SwiftUI

struct ContentView: View {
    @State private var circleDragg = CGSize.zero
    @State private var offset = CGSize.zero
    @State private var isTapped = false

    var body: some View {
        VStack {
            Circle()
                .fill(.blue)
                .frame(width: isTapped ? 100 : 60, height: isTapped ? 100 : 60)
                .animation(.easeInOut(duration: 0.2), value: isTapped)
                .onTapGesture {
                    isTapped.toggle()
                }
                .offset(x: circleDragg.width + offset.width,
                        y: circleDragg.height + offset.height
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            circleDragg = value.translation
                        }
                        .onEnded { value in
                            offset.width += value.translation.width
                            offset.height += value.translation.height
                            circleDragg = .zero
                        }
                )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
