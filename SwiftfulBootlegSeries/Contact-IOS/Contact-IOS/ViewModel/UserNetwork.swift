import Foundation

class UserNetwork {
    
    static let shared = UserNetwork()
    private let apiUrl = "https://dummyjson.com/users"
    
    private init() {}
    
    func ApiService() async throws -> [User] {
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        do {
            
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            return userResponse.users  
        } catch {
            throw error
        }
    }
}
