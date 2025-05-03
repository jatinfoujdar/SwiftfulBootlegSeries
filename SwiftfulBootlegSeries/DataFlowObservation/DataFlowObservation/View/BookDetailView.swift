//
import SwiftUI

// Detail view to edit a single book's availability
struct BookDetailView: View {
    @Binding var book: Book

    var body: some View {
        VStack(spacing: 20) {
            Text(book.title)
                .font(.largeTitle)
            Toggle("Available", isOn: $book.isAvailable)
                .padding()
        }
        .padding()
        .navigationTitle("Details")
    }
}





