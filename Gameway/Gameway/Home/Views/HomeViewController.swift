//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    var sectionVM: SectionViewModel
    
    private var collectionView: UICollectionView!
    private var skeletonLoaderTableView: UITableView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(viewModel sectionVM: SectionViewModel) {
        self.sectionVM = sectionVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionVM.fetchSections { [weak self] in
            self?.skeletonLoaderTableView.removeFromSuperview()
            
            self?.setCurrentViewInterface()
            self?.setCollectionViewSettings()
            self?.createDataSource()
            self?.reloadData()
        }
        
        setTableViewSettings()
    }
    
    private func setTableViewSettings() {
        skeletonLoaderTableView = UITableView(frame: view.bounds)
        skeletonLoaderTableView.backgroundColor = .darkKnight
        skeletonLoaderTableView.alwaysBounceVertical = false
        
        view.addSubview(skeletonLoaderTableView)
        
        skeletonLoaderTableView.register(SkeletonHomeCell.self, forCellReuseIdentifier: SkeletonHomeCell.identifier)
        skeletonLoaderTableView.delegate = self
        skeletonLoaderTableView.dataSource = self
    }
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
    
    private func setCollectionViewSettings() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkKnight
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(HomeGiveawayCell.self, forCellWithReuseIdentifier: HomeGiveawayCell.identifier)
    }
}

// MARK: - Diffable Data Source

extension HomeViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            return self?.configure(HomeGiveawayCell.self, with: item, for: indexPath)
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            sectionHeader.setTitleText(title: section.title, subtitle: section.subtitle)
            return sectionHeader
        }
    }
    
    private func configure<T: ConfigCell>(_ cellType: T.Type, with item: Item, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError()
        }
        
        cell.configure(with: item as? T.Request)
        return cell
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sectionVM.sections)
        
        for section in sectionVM.sections {
            switch section.type {
            case .popular:
                snapshot.appendItems(Array(section.items.prefix(8)), toSection: section)
            case .recent:
                snapshot.appendItems(Array(section.items.prefix(16)), toSection: section)
            case .valuable:
                snapshot.appendItems(Array(section.items.prefix(10)), toSection: section)
            }
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
        config.interSectionSpacing = 40
        layout.configuration = config
        return layout
    }
    
    private func createHomeGiveawaySection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(1/3))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(50))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

// MARK: - UITableView Protocol

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonHomeCell.identifier, for: indexPath) as! SkeletonHomeCell
        cell.configure(with: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 3 + 50
    }
}
