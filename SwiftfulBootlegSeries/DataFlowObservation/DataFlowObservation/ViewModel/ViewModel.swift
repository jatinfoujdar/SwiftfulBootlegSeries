import Foundation
import SwiftUI


class BookListModel: ObservableObject{
    @Published var books: [Book] = []
    
    init(){
        generateBooks()
    }
    
    private func generateBooks(){
        books = (1...101).map{
            Book(title: "Book \($0)", isAvailable: Bool.random(), color: Color.random())
        }
    }
}
extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0.3...1),
            green: Double.random(in: 0.3...1),
            blue: Double.random(in: 0.3...1)
        )
    }
}

