//
//  Section.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation

enum HomeSectionModelType: CaseIterable {
    case popular
    case recent
    case valuable
    case soonExpired
    case loading
}

struct HomeSectionModel: Hashable {
    let id: String
    let type: HomeSectionModelType
    let title: String
    let subtitle: String
    let items: [Item]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: HomeSectionModel, rhs: HomeSectionModel) -> Bool {
        return lhs.id == rhs.id
    }
}
