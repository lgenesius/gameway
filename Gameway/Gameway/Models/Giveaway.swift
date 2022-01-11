//
//  Giveaway.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import Foundation

struct Giveaway: Decodable, Hashable {
    let id: Int
    let title: String
    let worth: String
    let thumbnail: String
    let image: String
    let description: String
    let instructions: String
    let openGiveawayURL: String
    let publishedDate: String
    let type: String
    let platforms: String
    let endDate: String
    let users: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case worth
        case thumbnail
        case image
        case description
        case instructions
        case openGiveawayURL = "open_giveaway_url"
        case publishedDate = "published_date"
        case type
        case platforms
        case endDate = "end_date"
        case users
        case status
    }
}
