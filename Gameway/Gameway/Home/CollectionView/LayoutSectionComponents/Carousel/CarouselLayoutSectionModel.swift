//
//  CarouselLayoutSectionModel.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

final class CarouselLayoutSectionModel: HomeLayoutSectionModel {
    var carouselItems: [CarouselLayoutItemModel] {
        return items as? [CarouselLayoutItemModel] ?? []
    }
    
    required init(items: [CarouselLayoutItemModel]) {
        super.init(items: items)
    }
}
