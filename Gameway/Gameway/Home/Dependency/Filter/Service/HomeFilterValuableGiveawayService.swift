//
//  HomeFilterValuableGiveawayService.swift
//  Gameway
//
//  Created by Luis Genesius on 03/11/24.
//

import Foundation

final class HomeFilterValuableGiveawayService: HomeGiveawayFilterServiceProtocol {
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        guard !giveaways.isEmpty else { return [] }
        return giveaways.sorted(by: { Double($0.worth.dropFirst()) ?? 0.0 > Double($1.worth.dropFirst()) ?? 0.0 })
    }
}
