

import SwiftUI

struct ColorItem: Identifiable{
    let id =  UUID()
    let color : Color
}

struct MainView: View {
    @State private var currentIndex = 0
    var item: [ColorItem] = [
        ColorItem(color: .red),
        ColorItem(color: .yellow),
        ColorItem(color: .green),
        ColorItem(color: .blue),
        ColorItem(color: .cyan),
        ColorItem(color: .blue)
    ]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MainView()
}
