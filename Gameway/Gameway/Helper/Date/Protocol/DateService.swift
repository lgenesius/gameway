//
//  DateService.swift
//  Gameway
//
//  Created by Luis Genesius on 14/02/22.
//

import Foundation

protocol DateService {}

extension DateService {
    func convertStringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    func getDayDifference(from startDate: Date, to endDate: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day
    }
}
