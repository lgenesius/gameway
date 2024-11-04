//
//  HomeCollectionLayoutSectionProvider.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import UIKit

enum HomeCollectionLayoutSectionHeaderType {
    case `default`
}

enum HomeCollectionLayoutSectionType {
    case carousel
    case loading
}

protocol HomeLayoutSectionProviderProtocol {
    
    /// Provide the collection layout section according to the type in the parameter and also will be provided with section header type if needed.
    /// - Parameters:
    ///   - type: Will used to determine the interface layout section you needed.
    ///   - sectionHeaderType: Will used to determine the interface the section header you needed. If this is `nil` then the section will not have any header.
    /// - Returns: return the `NSCollectionLayoutSection`.
    func provideCollectionLayoutSection(
        type: HomeCollectionLayoutSectionType,
        sectionHeaderType: HomeCollectionLayoutSectionHeaderType?
    ) -> NSCollectionLayoutSection
}

final class HomeLayoutSectionProvider: HomeLayoutSectionProviderProtocol {
    
    func provideCollectionLayoutSection(
        type: HomeCollectionLayoutSectionType,
        sectionHeaderType: HomeCollectionLayoutSectionHeaderType?
    ) -> NSCollectionLayoutSection {
        var layoutSection: NSCollectionLayoutSection
        
        switch type {
        case .carousel:
            layoutSection = CarouselLayoutSectionInterfaceConfig().getLayoutSection()
        case .loading:
            layoutSection = LoadingLayoutSectionInterfaceConfig().getLayoutSection()
        }
        
        if let sectionHeaderType: HomeCollectionLayoutSectionHeaderType {
            switch sectionHeaderType {
            case .default:
                let layoutSectionHeader: NSCollectionLayoutBoundarySupplementaryItem = createDefaultSectionHeader()
                layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
            }
        }
        
        return layoutSection
    }
    
    private func createDefaultSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(50)
        )
        let layoutSectionHeader: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }
}
