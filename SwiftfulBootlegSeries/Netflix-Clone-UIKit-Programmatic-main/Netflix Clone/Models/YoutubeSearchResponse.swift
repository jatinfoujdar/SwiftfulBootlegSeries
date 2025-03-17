//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Aarish Khanna on 24/01/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    
    let items: [VideoElement]
    
    
}

struct VideoElement: Codable {
    let id: IdVideoElement
    
    
}

struct IdVideoElement: Codable{
    let kind: String
    let videoId: String
}
