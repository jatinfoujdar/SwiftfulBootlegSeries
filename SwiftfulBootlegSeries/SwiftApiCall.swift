//
//  SwiftApiCall.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 08/10/24.
//

import SwiftUI

struct SwiftApiCall: View {
    var body: some View {
        VStack(spacing: 20){
            Circle()
                .foregroundStyle(.gray)
                .frame(width: 120,height: 120)
            Text("Username")
                .bold()
                .font(.title3)
            Text("this is where Bio will go. Lets make it long so that span will open in two line ")
                .padding()
            Spacer()
        }
        .padding()
    }
    func getUser() async throws -> GithubUser{
        let endpoint = "https://api.github.com/jatinfoujdar"
        
        guard let url = URL(string: endpoint)
        else{
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        }catch{
            throw GHError.invalidData
        }
        
    }
}

#Preview {
    SwiftApiCall()
}


struct GithubUser: Codable{
    let login: String
    let avatarUrl: String
    let bio: String
    
}
enum GHError : Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
