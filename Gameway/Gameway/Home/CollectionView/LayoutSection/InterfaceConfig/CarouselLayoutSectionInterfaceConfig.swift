//
//  CarouselLayoutSectionInterfaceConfig.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import UIKit

final class CarouselLayoutSectionInterfaceConfig: LayoutSectionInterfaceConfigProtocol {
    func getLayoutSection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 10
        )
        
        let layoutGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .fractionalHeight(1/3)
        )
        let layoutGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitems: [layoutItem]
        )
        
        let layoutSection: NSCollectionLayoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        return layoutSection
    }
}
