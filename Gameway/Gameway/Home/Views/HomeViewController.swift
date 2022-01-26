//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    private let sectionVM = SectionViewModel()
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Giveaway>?

    override func viewDidLoad() {
        super.viewDidLoad()
        sectionVM.fetchSections()
        setCurrentViewInterface()
        setCollectionViewSettings()
        
        createDataSource()
        reloadData()
    }
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
    
    private func setCollectionViewSettings() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkKnight
        view.addSubview(collectionView)
        
        collectionView.register(HomeGiveawayCell.self, forCellWithReuseIdentifier: HomeGiveawayCell.identifier)
    }
}

// MARK: - Diffable Data Source

extension HomeViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Giveaway>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, giveaway in
            return self?.configure(HomeGiveawayCell.self, with: giveaway, for: indexPath)
        })
    }
    
    private func configure<T: ConfigCell>(_ cellType: T.Type, with giveaway: Giveaway, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError()
        }
        
        cell.configure(with: giveaway)
        return cell
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Giveaway>()
        snapshot.appendSections(sectionVM.sections)
        
        for section in sectionVM.sections {
            snapshot.appendItems(section.giveaways, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
}

// MARK: - Compositional Layout

extension HomeViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = self.sectionVM.sections[sectionIndex]
            
            return self.createHomeGiveawaySection(using: section)
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createHomeGiveawaySection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
}
