import SwiftUI

struct ColorItem: Identifiable {
    let id = UUID()
    let color: Color
}

struct MainView: View {
    @State private var currentIndex = 0
    var items: [ColorItem] = [
        ColorItem(color: .red),
        ColorItem(color: .yellow),
        ColorItem(color: .green),
        ColorItem(color: .blue),
        ColorItem(color: .cyan),
        ColorItem(color: .purple) // Added purple for variety
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    CardTransitions(
                        color: item.color,
                        isCurrent: .constant(currentIndex == index) // Compare index with currentIndex
                    )
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    .background(GeometryReader { geo -> Color in
                        let minX = geo.frame(in: .global).minX
                        DispatchQueue.main.async {
                            if abs(minX) < 100 {
                                currentIndex = index // Update currentIndex based on the position
                            }
                        }
                        return Color.clear
                    })
                    .frame(width: 300, height: 200) // Adjust card size if needed
                }
            }
        }
    }
}

#Preview {
    MainView()
}
