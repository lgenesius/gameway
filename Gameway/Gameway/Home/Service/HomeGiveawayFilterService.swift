//
//  HomeGiveawayFilterService.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

protocol HomeGiveawayFilterServiceProtocol {
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway]
}

final class HomeFilterSoonExpiredService: HomeGiveawayFilterServiceProtocol {
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        guard !giveaways.isEmpty else { return [] }
        let sortedSoonExpiredGiveaways: [Giveaway] = giveaways.sorted(by: {
            let previousGiveawayEndDate: Date? = DateHelper.convertStringToDate($0.endDate)
            let nextGiveawayEndDate: Date? = DateHelper.convertStringToDate($1.endDate)
            
            guard let previousEndDate: Date = previousGiveawayEndDate,
                  let previousDayDiff = DateHelper.getDayDifference(from: Date(), to: previousEndDate),
            previousDayDiff >= 0 else {
                return false
            }
            guard let nextEndDate: Date = nextGiveawayEndDate,
                  let nextDayDiff = DateHelper.getDayDifference(from: Date(), to: nextEndDate),
                  nextDayDiff >= 0
            else { return true }

            return previousEndDate < nextEndDate
        })
        return sortedSoonExpiredGiveaways
    }
}

protocol RecentGiveawayTypeProtocol { }

enum DirectGiveawayType: String, RecentGiveawayTypeProtocol {
    case game = "Game"
    case loot = "DLC"
    case beta = "Early Access"
}

enum ConditionalGiveawayType: RecentGiveawayTypeProtocol {
    case otherThanGame
}

final class HomeFilterRecentGiveawayService: HomeGiveawayFilterServiceProtocol {
    private let recentGiveawayType: RecentGiveawayTypeProtocol
    
    init(recentGiveawayType: RecentGiveawayTypeProtocol) {
        self.recentGiveawayType = recentGiveawayType
    }
    
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        if let directGiveawayType: DirectGiveawayType = recentGiveawayType as? DirectGiveawayType {
            return giveaways.filter { $0.type == directGiveawayType.rawValue }
        }
        else if let conditionalGiveawayType: ConditionalGiveawayType = recentGiveawayType as? ConditionalGiveawayType {
            switch conditionalGiveawayType {
            case .otherThanGame:
                return giveaways.filter { $0.type != DirectGiveawayType.game.rawValue }
            }
        }
        return []
    }
}

final class HomeFilterValuableGiveawayService: HomeGiveawayFilterServiceProtocol {
    func fiterGiveaways(_ giveaways: [Giveaway]) -> [Giveaway] {
        guard !giveaways.isEmpty else { return [] }
        return giveaways.sorted(by: { Double($0.worth.dropFirst()) ?? 0.0 > Double($1.worth.dropFirst()) ?? 0.0 })
    }
}
