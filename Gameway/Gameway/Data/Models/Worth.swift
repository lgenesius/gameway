//
//  Worth.swift
//  Gameway
//
//  Created by Luis Genesius on 17/02/22.
//

import Foundation

struct Worth: Decodable {
    let activeGiveawaysNumber: Int
    let worthEstimationUSD: String
    
    enum CodingKeys: String, CodingKey {
        case activeGiveawaysNumber = "active_giveaways_number"
        case worthEstimationUSD = "worth_estimation_usd"
    }
}
