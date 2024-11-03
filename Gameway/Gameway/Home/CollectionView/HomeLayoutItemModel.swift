//
//  HomeItemCell.swift
//  Gameway
//
//  Created by Luis Genesius on 04/06/23.
//

import Foundation

class HomeLayoutItemModel {
    let id: String
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
}

extension HomeLayoutItemModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension HomeLayoutItemModel: Equatable {
    static func == (lhs: HomeLayoutItemModel, rhs: HomeLayoutItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}
