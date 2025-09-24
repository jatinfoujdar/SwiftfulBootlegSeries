//
//  APIClient.swift
//  PowerPlay-Assignment
//
//  Created by jatin on 24/09/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decoding(Error)
    case network(Error)
    case http(statusCode: Int)
}

final class APIClient {
    static let shared = APIClient()

    private let urlSession: URLSession
    private let baseURLString = "https://fakeapi.net/products"

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchProducts(page: Int, limit: Int, category: String, completion: @escaping (Result<PaginatedResponse, APIError>) -> Void) {
        var components = URLComponents(string: baseURLString)
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        queryItems.append(URLQueryItem(name: "category", value: category))
        components?.queryItems = queryItems

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
              
                completion(.failure(.network(error)))
                return
            }

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                completion(.failure(.http(statusCode: http.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(PaginatedResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        task.resume()
    }
}


