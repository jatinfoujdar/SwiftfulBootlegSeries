import SwiftUI

// Sample data structure for Album
struct Album: Identifiable {
    var id = UUID()
    var imageName: String
}

struct ContentView: View {
    @Namespace var namespace

    // Sample albums array with images named "1.jpg", "2.jpg", etc., in the asset catalog
    let albums = [
        Album(imageName: "1"),  // These refer to the image names in the asset catalog
        Album(imageName: "2"),
        Album(imageName: "3"),
        Album(imageName: "4")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(albums) { album in
                        // Image names are from the album data, e.g., "1", "2", etc., in the asset catalog
                        NavigationLink {
                            // Destination view: Zoomed-in image view
                            Image(album.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .matchedGeometryEffect(id: album.id, in: namespace) // Matched geometry effect on destination
                        } label: {
                            // Source view in the grid: Thumbnails
                            Image(album.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 150)
                                .cornerRadius(8.0)
                                .matchedGeometryEffect(id: album.id, in: namespace) // Matched geometry effect on source
                                .navigationTransition(.zoom(sourceID: album.id, in: namespace)) // Zoom animation on tap
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
