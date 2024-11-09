//
//  BorderBoxLayoutSectionModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/11/24.
//

import Foundation

final class BorderBoxLayoutSectionModel: HomeLayoutSectionModel {
    var borderBoxItems: [BorderBoxLayoutItemModel] {
        return items as? [BorderBoxLayoutItemModel] ?? []
    }
    
    required init(items: [BorderBoxLayoutItemModel]) {
        super.init(items: items)
    }
}
