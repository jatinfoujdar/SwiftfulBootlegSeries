import SwiftUI

struct ColorChangingView: View {
    @State private var isTapped = false
    private let originalColor = Color.blue
    private let tappedColor = Color.red

    var body: some View {
        Rectangle()
            .fill(isTapped ? tappedColor : originalColor)
            .frame(width: 200, height: 200)
            .cornerRadius(20)
            .onTapGesture {
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isTapped = false
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isTapped)
    }
}

#Preview {
    ColorChangingView()
}
