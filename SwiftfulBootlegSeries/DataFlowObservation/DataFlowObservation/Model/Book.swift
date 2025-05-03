import SwiftUI

// Define the Book model
struct Book: Identifiable {
    let id = UUID()
    let title: String
    var isAvailable: Bool
    var color: Color
}



// Main BookListView with @State and @Binding



