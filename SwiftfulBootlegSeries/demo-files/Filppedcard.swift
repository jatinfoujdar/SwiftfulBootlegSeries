import SwiftUI

struct ContentView: View {
    @State private var isFlipped = false
    var body: some View {
        ZStack{
            CardView(text: "front", color: .blue)
                .opacity(isFlipped ? 0.0 : 1.0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x:0, y: 1, z:0)
                )
            
            CardView(text: "back", color: .green)
                .opacity(isFlipped ?  1.0 : 0.0 )
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x:0, y:1 , z:0)
                )
        }
        .frame(width: 200, height: 300)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                isFlipped.toggle()
            }
        }
    }}
struct CardView: View{
    var text: String
    var color: Color
    var body: some View{
        Rectangle()
            .fill(color)
            .overlay{
                Text(text)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
