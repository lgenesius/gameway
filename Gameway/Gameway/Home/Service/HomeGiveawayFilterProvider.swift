//
//  HomeGiveawayFilterProvider.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

protocol HomeGiveawayFilterProviderProtocol {
    func filterToGetSoonExpiredGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
    func filterToGetRecentGiveaways(
        _ giveaways: [Giveaway],
        type: RecentGiveawayTypeProtocol
    ) -> [Giveaway]
    func filterToGetValueableGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
}

final class HomeGiveawayFilterProvider: HomeGiveawayFilterProviderProtocol {
    func filterToGetSoonExpiredGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterSoonExpiredService().fiterGiveaways(giveaways)
    }
    
    func filterToGetRecentGiveaways(
        _ giveaways: [Giveaway],
        type: RecentGiveawayTypeProtocol
    ) -> [Giveaway] {
        return HomeFilterRecentGiveawayService(recentGiveawayType: type).fiterGiveaways(giveaways)
    }
    
    func filterToGetValueableGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        return HomeFilterValuableGiveawayService().fiterGiveaways(giveaways)
    }
}

