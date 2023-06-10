//
//  CardLayoutSectionInterfaceConfig.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import UIKit

final class CardLayoutSectionInterfaceConfig: LayoutSectionInterfaceConfigProtocol {
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
            trailing: 0
        )
        
        let layoutGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2)
        )
        let layoutGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutGroupSize,
            subitems: [layoutItem]
        )
        layoutGroup.interItemSpacing = .fixed(16.0)
        
        let layoutSection: NSCollectionLayoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}
