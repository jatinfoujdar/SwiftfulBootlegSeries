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
            errorMessage = "Failed to fetch user: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }

    func getUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/US"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let message = "Unexpected status code: \(httpResponse.statusCode)"
            print(message)
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw GHError.invalidData
        }
    }
}

#Preview {
    SwiftApiCall()
}

struct GithubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
