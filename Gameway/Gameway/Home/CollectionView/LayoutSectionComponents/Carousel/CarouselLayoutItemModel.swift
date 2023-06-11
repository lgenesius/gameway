//
//  CarouselLayoutItemModel.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

final class CarouselLayoutItemModel: HomeLayoutItemModel {
    let giveaway: Giveaway
    
    required init(giveaway: Giveaway) {
        self.giveaway = giveaway
        super.init()
    }
}
