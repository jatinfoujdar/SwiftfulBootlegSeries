import Foundation

struct RestaurantResponse: Codable {
    let message: String
    let data: RestaurantData
}

struct RestaurantData: Codable {
    let statusCode: Int
    let data: RestaurantList
}

struct RestaurantList: Codable {
    let statusMessage: String
    let cards: [Card]
}

struct Card: Codable {
    let card: CardInfo
}

struct CardInfo: Codable {
    let gridElement: GridElement
}

struct GridElement: Codable {
    let infoWithStyle: InfoWithStyle
}

struct InfoWithStyle: Codable {
    let restaurants: [Restaurant]
}

struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let cloudinaryImageId: String
    let locality: String
    let areaName: String
    let costForTwo: String
    let cuisines: [String]
    let avgRating: Double
    let parentId: String
    let avgRatingString: String
    let totalRatingsString: String
    let sla: SLA
    let availability: Availability
    let badges: [Badge]
    let isOpen: Bool
    let type: String
    let badgesV2: [BadgeV2]
    let aggregatedDiscountInfoV3: AggregatedDiscountInfoV3
    let differentiatedUi: DifferentiatedUI
    let reviewsSummary: ReviewsSummary
    let displayType: String
    let restaurantOfferPresentationInfo: RestaurantOfferPresentationInfo
    let externalRatings: ExternalRatings
    let ratingsDisplayPreference: String
    let analytics: Analytics
    let cta: CTA
}

// Add the following structs to match the JSON data
struct SLA: Codable {
    // Add properties as needed
}

struct Availability: Codable {
    // Add properties as needed
}

struct Badge: Codable {
    // Add properties as needed
}

struct BadgeV2: Codable {
    // Add properties as needed
}

struct AggregatedDiscountInfoV3: Codable {
    // Add properties as needed
}

struct DifferentiatedUI: Codable {
    // Add properties as needed
}

struct ReviewsSummary: Codable {
    // Add properties as needed
}

struct RestaurantOfferPresentationInfo: Codable {
    // Add properties as needed
}

struct ExternalRatings: Codable {
    // Add properties as needed
}

struct Analytics: Codable {
    // Add properties as needed
}

struct CTA: Codable {
    // Add properties as needed
}
//
//import SwiftUI
//
//struct RestaurantView: View {
//    @State private var restaurants: [RestaurantResponse.Data.Card.CardInfo.GridElement.InfoElement.Restaurant] = []
//    
//    var body: some View {
//        List(restaurants, id: \.id) { restaurant in
//            Text(restaurant.name)
//        }
//        .onAppear {
//            guard let url = URL(string: "https://food-wagon-backend.onrender.com/api/restaurants?lat=25.61011402528211&lng=85.116419903934") else {
//                return
//            }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error {
//                    print("Error fetching restaurants: \(error)")
//                    return
//                }
//                
//                guard let data = data else {
//                    return
//                }
//                
//                do {
//                    let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        self.restaurants = restaurantResponse.data.cards[1].card.card.gridElement.infoElement.restaurants
//                    }
//                } catch {
//                    print("Error parsing restaurant data: \(error)")
//                }
//            }.resume()
//        }
//    }
//}
//
//struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
//}
