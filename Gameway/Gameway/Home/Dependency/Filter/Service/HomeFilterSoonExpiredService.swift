//
//  HomeFilterSoonExpiredService.swift
//  Gameway
//
//  Created by Luis Genesius on 03/11/24.
//

import Foundation

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
