//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModelProtocol
    
    private var collectionView: UICollectionView!
    
    private lazy var skeletonLoaderTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .darkKnight
        tableView.alwaysBounceVertical = false
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(viewModel homeViewModel: HomeViewModelProtocol) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentViewInterface()
        setTableViewSettings()
        
        homeViewModel.onViewModelDidLoad()
    }
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
    
    private func setTableViewSettings() {
        view.addSubview(skeletonLoaderTableView)
    }
    
    private func setCollectionViewSettings() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkKnight
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
}

// MARK: - Diffable Data Source

extension HomeViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            return self?.configure(
                HomeCollectionViewCell.self,
                with: item,
                for: indexPath
            )
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader: SectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else {
                return nil
            }
            
            guard let firstItem: Item = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section: Section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            sectionHeader.setTitleText(title: section.title, subtitle: section.subtitle)
            return sectionHeader
        }
    }
    
    private func configure<T: ConfigCell>(_ cellType: T.Type, with item: Item, for indexPath: IndexPath) -> T {
        guard let cell: T = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError()
        }
        
        cell.configure(with: item as? T.Request)
        return cell
    }
    
    private func reloadData(sections: [Section]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        
        for section in sections {
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
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            
            return self.createHomeGiveawaySection()
        }
        
        let config: UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config
        return layout
    }
    
    private func createHomeGiveawaySection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 10
        )
        
        let layoutGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(1/3))
        let layoutGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection: NSCollectionLayoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader: NSCollectionLayoutBoundarySupplementaryItem = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(50))
        let layoutSectionHeader: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }
}

// MARK: - UITableView Protocol

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SkeletonTableViewCell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as! SkeletonTableViewCell
        cell.configure(with: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 3 + 50
    }
}

// MARK: - UICollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - HomeViewModel Delegate

extension HomeViewController: HomeViewModelDelegate {
    func processSectionsFromViewModel(sections: [Section]) {
        DispatchQueue.main.async { [weak self] in
            guard let self: HomeViewController = self else { return }
            
            self.skeletonLoaderTableView.removeFromSuperview()
            
            self.setCollectionViewSettings()
            self.createDataSource()
            self.reloadData(sections: sections)
        }
    }
    
    func notifySuccessFetchSections() {
        
    }
    
    func notifyFailedFetchSections(error: Error) {
        
    }
}
