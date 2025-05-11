import SwiftUI

struct ContentView: View {
    @State private var isTapped = false
    var body: some View {
        Circle()
            .fill(isTapped ? Color.red : Color.blue)
            .frame(width: 200, height: 200)
            .onTapGesture {
                isTapped = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    isTapped = false
                }

            }
    }
}

#Preview {
    ContentView()
}
