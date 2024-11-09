//
//  BorderBoxLayoutSectionInterfaceConfig.swift
//  Gameway
//
//  Created by Luis Genesius on 09/11/24.
//

import UIKit

final class BorderBoxLayoutSectionInterfaceConfig: LayoutSectionInterfaceConfigProtocol {
    func getLayoutSection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 16.0,
            bottom: .zero,
            trailing: .zero
        )
        
        let layoutGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .fractionalHeight(1/3)
        )
        let layoutGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitems: [layoutItem]
        )
        
        let layoutSection: NSCollectionLayoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: .zero,
            bottom: .zero,
            trailing: 16.0
        )
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        return layoutSection
    }
}
