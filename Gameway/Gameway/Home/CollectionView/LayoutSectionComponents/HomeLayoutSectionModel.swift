//
//  Section.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation

class HomeLayoutSectionModel {
    let id: String
    var title: String?
    var subtitle: String?
    var items: [HomeLayoutItemModel]
    
    init(
        id: String = UUID().uuidString,
        items: [HomeLayoutItemModel] = []
    ) {
        self.id = id
        self.items = items
    }
}

extension HomeLayoutSectionModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension HomeLayoutSectionModel: Equatable {
    static func == (lhs: HomeLayoutSectionModel, rhs: HomeLayoutSectionModel) -> Bool {
        lhs.id == rhs.id
    }
}
