//
//  HomeGiveawayFilterProvider.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

protocol HomeGiveawayFilterProviderProtocol {
    func filterToGetSoonExpiredGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
    func filterToGetRecentGameGiveaways( _ giveaways: [Giveaway]) -> [Giveaway]
    func filterToGetRecentNonGameGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
    func filterToGetValueableGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
}

final class HomeGiveawayFilterProvider: HomeGiveawayFilterProviderProtocol {
    func filterToGetSoonExpiredGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterSoonExpiredService().fiterGiveaways(giveaways)
    }
    
    func filterToGetRecentGameGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterRecentGiveawayService(recentGiveawayType: [.game]).fiterGiveaways(giveaways)
    }
    
    func filterToGetRecentNonGameGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterRecentGiveawayService(recentGiveawayType: [.loot, .beta]).fiterGiveaways(giveaways)
    }
    
    func filterToGetValueableGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterValuableGiveawayService().fiterGiveaways(giveaways)
    }
}

