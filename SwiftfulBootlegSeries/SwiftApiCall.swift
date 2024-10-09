import SwiftUI

struct SwiftApiCall: View {
    @State private var user: GithubUser?
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            if let user = user {
                AsyncImage(url: URL(string: user.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 120, height: 120)
                } placeholder: {
                    Circle()
                        .foregroundStyle(.gray)
                        .frame(width: 120, height: 120)
                }

                Text(user.login)
                    .bold()
                    .font(.title3)

                Text(user.bio.isEmpty ? "No bio available" : user.bio)

                HStack {
                    Text("Followers: \(user.followers)")
                    Spacer()
                    Text("Following: \(user.following)")
                }
                .padding()
            } else {
                Text(errorMessage ?? "Loading...")
                    .padding()
                    .foregroundColor(errorMessage == nil ? .black : .red)
            }
            Spacer()
        }
        .padding()
        .task {
            await fetchUser()
        }
    }

    func fetchUser() async {
        do {
            user = try await getUser()
        } catch {
            // Log the error with more detail
            errorMessage = "Failed to fetch user: \(error.localizedDescription)"
            print("Error fetching user: \(error)")
        }
    }

    func getUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/octocat"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        // Check the status code
        if httpResponse.statusCode != 200 {
            let message = "Unexpected status code: \(httpResponse.statusCode)"
            let responseBody = String(data: data, encoding: .utf8) ?? "No data"
            print("\(message)\nResponse Body: \(responseBody)")
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            print("Decoding error: \(error), data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw GHError.invalidData
        }
    }


    func fetchFollowersCount(username: String) async throws -> Int {
        let endpoint = "https://api.github.com/users/\(username)/followers"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data.count
    }

    func fetchFollowingCount(username: String) async throws -> Int {
        let endpoint = "https://api.github.com/users/\(username)/following"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data.count
    }
}

#Preview {
    SwiftApiCall()
}

struct GithubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
    let followers: Int
    let following: Int
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
