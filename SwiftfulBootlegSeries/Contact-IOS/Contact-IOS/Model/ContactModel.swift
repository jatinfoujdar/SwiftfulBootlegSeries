import Foundation


struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let username: String
    let password: String
    let image: String
}


struct UserResponse: Codable {
    let users: [User]
}
