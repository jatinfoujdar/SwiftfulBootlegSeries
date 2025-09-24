//
//  Models.swift
//  PowerPlay-Assignment
//
//  Created by jatin on 24/09/25.
//

import Foundation

// MARK: - API Models

struct PaginatedResponse: Codable {
    let products: [Product]
    let nextPage: Int?
    let page: Int?
    let limit: Int?
    let total: Int?

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

     
        if let productsKey = container.allKeys.first(where: { $0.stringValue == "products" }) {
            products = try container.decode([Product].self, forKey: productsKey)
        } else if let dataKey = container.allKeys.first(where: { $0.stringValue == "data" }) {
            products = try container.decode([Product].self, forKey: dataKey)
        } else {
            products = []
        }

        if let nextKey = container.allKeys.first(where: { $0.stringValue == "nextPage" }) {
            nextPage = try? container.decodeIfPresent(Int.self, forKey: nextKey)
        } else if let pageKey = container.allKeys.first(where: { $0.stringValue == "next" }) {
            nextPage = try? container.decodeIfPresent(Int.self, forKey: pageKey)
        } else {
            nextPage = try? container.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "next_page")!)

        }

        
        if container.allKeys.contains(where: { $0.stringValue == "pagination" }) {
            let paginationKey = DynamicCodingKeys(stringValue: "pagination")!
            let pagination = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: paginationKey)
            page = try? pagination.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "page")!)
            limit = try? pagination.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "limit")!)
            total = try? pagination.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "total")!)
        } else {
            page = try? container.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "page")!)
            limit = try? container.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "limit")!)
            total = try? container.decodeIfPresent(Int.self, forKey: DynamicCodingKeys(stringValue: "total")!)
        }
    }
}

struct Product: Codable {
    let id: Int?
    let title: String
    let description: String
    let category: String
    let price: Double
    let imageUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case price
        case imageUrl = "image"
    }

   
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try? c.decodeIfPresent(Int.self, forKey: .id)
        title = (try? c.decode(String.self, forKey: .title)) ?? "Untitled"
        description = (try? c.decode(String.self, forKey: .description)) ?? "No description available."
        category = (try? c.decode(String.self, forKey: .category)) ?? "Unknown"
        if let priceString = try? c.decodeIfPresent(String.self, forKey: .price), let p = Double(priceString) {
            price = p
        } else {
            price = (try? c.decode(Double.self, forKey: .price)) ?? 0
        }
        if let urlString = try? c.decodeIfPresent(String.self, forKey: .imageUrl) {
            imageUrl = URL(string: urlString)
        } else {
            imageUrl = try? c.decodeIfPresent(URL.self, forKey: .imageUrl)
        }
    }
}



struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

  
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }

   
    init?(stringValue: String) {
        self.init(nonOptionalString: stringValue)
    }

   
    init(nonOptionalString stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
}



