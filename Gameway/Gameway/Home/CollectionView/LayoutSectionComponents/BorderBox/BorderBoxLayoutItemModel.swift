//
//  BorderBoxLayoutItemModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/11/24.
//

import Foundation

final class BorderBoxLayoutItemModel: HomeLayoutItemModel {
    let giveaway: Giveaway
    
    required init(giveaway: Giveaway) {
        self.giveaway = giveaway
        super.init()
    }
}
