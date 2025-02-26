import Foundation



class NetworkManager{
    
    static let shared = NetworkManager()

    private let apiUrl = "https://api.restful-api.dev/objects"
    
    private init() {}
    
    func ApiService() async throws -> [DeviceData]{
        guard let url = URL(string: apiUrl) else{
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let(data, response) = try await URLSession.shared.data(for: req)
        
        
        if let jsondata = String(data: data,encoding: .utf8){
            print(jsondata)
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        do{
            let deviceData = try decoder.decode([DeviceData].self, from: data)
            return deviceData
        } catch {
            throw error
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
