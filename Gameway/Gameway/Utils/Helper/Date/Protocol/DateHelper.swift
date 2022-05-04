//
//  DateHelper.swift
//  Gameway
//
//  Created by Luis Genesius on 14/02/22.
//

import Foundation

final class DateHelper {
    static func convertStringToDate(_ string: String) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    static func getDayDifference(from startDate: Date, to endDate: Date) -> Int? {
        let calendar: Calendar = Calendar.current
        let components: DateComponents = calendar.dateComponents(
            [.day],
            from: startDate,
            to: endDate
        )
        return components.day
    }
    
    static func getSecondDifference(from startDate: Date, to endDate: Date) -> Int? {
        let calendar: Calendar = Calendar.current
        let components: DateComponents = calendar.dateComponents(
            [.second],
            from: startDate,
            to: endDate
        )
        return components.second
    }
}
