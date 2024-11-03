//
//  HomeFilterRecentGiveawayService.swift
//  Gameway
//
//  Created by Luis Genesius on 03/11/24.
//

import Foundation

enum HomeFilterRecentGiveawayType: String {
    case game = "Game"
    case loot = "DLC"
    case beta = "Early Access"
    case unknown = ""
}

final class HomeFilterRecentGiveawayService: HomeGiveawayFilterServiceProtocol {
    private let recentGiveawayTypes: Set<HomeFilterRecentGiveawayType>
    
    init(recentGiveawayType: Set<HomeFilterRecentGiveawayType>) {
        self.recentGiveawayTypes = recentGiveawayType
    }
    
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return giveaways.filter {
            let validatedType: HomeFilterRecentGiveawayType = HomeFilterRecentGiveawayType(rawValue: $0.type) ?? .unknown
            return recentGiveawayTypes.contains(validatedType)
        }
    }
}
