
import SwiftUI

struct BookListView: View {
    @State private var books: [Book] = []

    init() {
        _books = State(initialValue: (1...101).map {
            Book(title: "Book \($0)", isAvailable: Bool.random(), color: Color.random())
        })
    }

    var body: some View {
        NavigationView {
            List {
                ForEach($books) { $book in
                    NavigationLink(destination: BookDetailView(book: $book)) {
                        HStack {
                            Text(book.title)
                            Spacer()
                            Text(book.isAvailable ? "✅" : "❌")
                        }
                        .padding()
                        .background(book.color)
                        .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Books List")
        }
    }
}

#Preview {
    BookListView()
}
