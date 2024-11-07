//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

// MARK: - Typealias

private typealias LoadingCellRegistration = UICollectionView.CellRegistration<LoadingCardCollectionViewCell, LoadingLayoutItemModel>
private typealias CarouselCellRegistration = UICollectionView.CellRegistration<CarouselCardCollectionViewCell, CarouselLayoutItemModel>
private typealias HomeDiffableDataSource = UICollectionViewDiffableDataSource<HomeLayoutSectionModel, HomeLayoutItemModel>
private typealias HomeDiffableSupplementaryViewProvider = UICollectionViewDiffableDataSource<HomeLayoutSectionModel, HomeLayoutItemModel>.SupplementaryViewProvider

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var homeViewModel: HomeViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.backgroundColor = .mainDarkBlue
        collectionView.delegate = self
        collectionView.contentInset = .init(
            top: 16.0,
            left: .zero,
            bottom: 16.0,
            right: .zero
        )
        collectionView.register(
            CarouselCardCollectionViewCell.self,
            forCellWithReuseIdentifier: CarouselCardCollectionViewCell.identifier
        )
        collectionView.register(
            LoadingCardCollectionViewCell.self,
            forCellWithReuseIdentifier: LoadingCardCollectionViewCell.identifier
        )
        collectionView.register(
            DefaultSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DefaultSectionHeaderView.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var errorView: ErrorView = {
        let errorView: ErrorView = ErrorView(frame: view.bounds)
        errorView.delegate = self
        return errorView
    }()
    
    private lazy var dataSource: HomeDiffableDataSource = {
        let dataSource: UICollectionViewDiffableDataSource = createDiffableDataSource()
        dataSource.supplementaryViewProvider = provideSupplementaryViewProvider()
        return dataSource
    }()
    
    private let collectionLayoutProvider: HomeLayoutSectionProviderProtocol
    
    // MARK: - Initialization
    
    init(
        viewModel homeViewModel: HomeViewModelProtocol,
        collectionLayoutProvider: HomeLayoutSectionProviderProtocol = HomeLayoutSectionProvider()
    ) {
        self.homeViewModel = homeViewModel
        self.collectionLayoutProvider = collectionLayoutProvider
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func loadView() {
        super.loadView()
        setCurrentViewInterface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewSettings()
        homeViewModel.onViewModelDidLoad()
    }
    
    // MARK: - Interface
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        view.backgroundColor = .mainDarkBlue
    }
    
    private func setCollectionViewSettings() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Diffable Data Source

extension HomeViewController {
    private func getLoadingCellRegistration() -> LoadingCellRegistration {
        return LoadingCellRegistration { (_, _, _) in
            // No impl
        }
    }
    
    private func getCarouselCellRegistration() -> CarouselCellRegistration {
        return CarouselCellRegistration { (cell, indexPath, itemModel) in
            cell.configure(with: itemModel)
        }
    }
    
    private func createDiffableDataSource() -> HomeDiffableDataSource {
        let loadingCellRegistration: LoadingCellRegistration = getLoadingCellRegistration()
        let carouselCellRegistration: CarouselCellRegistration = getCarouselCellRegistration()
        
        return HomeDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self else { return nil }
                
                let sections: [HomeLayoutSectionModel] = self.homeViewModel.onViewModelReturnSections()
                guard indexPath.section < sections.count else { return nil }
                
                if sections[indexPath.section] is LoadingLayoutSectionModel,
                   let loadingItem: LoadingLayoutItemModel = item as? LoadingLayoutItemModel {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: loadingCellRegistration,
                        for: indexPath,
                        item: loadingItem
                    )
                }
                else if sections[indexPath.section] is CarouselLayoutSectionModel,
                        let carouselItem: CarouselLayoutItemModel = item as? CarouselLayoutItemModel {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: carouselCellRegistration,
                        for: indexPath,
                        item: carouselItem
                    )
                }
                else {
                    return nil
                }
            }
        )
    }
    
    private func provideSupplementaryViewProvider() -> HomeDiffableSupplementaryViewProvider? {
        return HomeDiffableSupplementaryViewProvider? { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader: DefaultSectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DefaultSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? DefaultSectionHeaderView else {
                return nil
            }
            
            guard let firstItem: HomeLayoutItemModel = self?.dataSource.itemIdentifier(for: indexPath) else { return nil }
            guard let section: HomeLayoutSectionModel = self?.dataSource.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            sectionHeader.setTitleText(
                title: section.title,
                subtitle: section.subtitle
            )
            return sectionHeader
        }
    }
    
    private func reloadData(sections: [HomeLayoutSectionModel], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeLayoutSectionModel, HomeLayoutItemModel>()
        snapshot.appendSections(sections)
        
        for section: HomeLayoutSectionModel in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - Compositional Layout

extension HomeViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            return self.selectLayoutSection(
                sectionIndex: sectionIndex,
                layoutEnvironment: layoutEnvironment
            )
        }
        
        let config: UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        layout.configuration = config
        return layout
    }
    
    private func selectLayoutSection(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        var layoutSectionType: HomeCollectionLayoutSectionType = .loading
        var sectionHeaderType: HomeCollectionLayoutSectionHeaderType?
        
        let sections: [HomeLayoutSectionModel] = homeViewModel.onViewModelReturnSections()
        
        guard sectionIndex < sections.count
        else {
            return collectionLayoutProvider.provideCollectionLayoutSection(
                type: layoutSectionType,
                sectionHeaderType: sectionHeaderType
            )
        }
        
        if sections[sectionIndex] is CarouselLayoutSectionModel {
            layoutSectionType = .carousel
            sectionHeaderType = .default
        }
        else {
            layoutSectionType = .loading
            sectionHeaderType = nil
        }
        
        return collectionLayoutProvider.provideCollectionLayoutSection(
            type: layoutSectionType,
            sectionHeaderType: sectionHeaderType
        )
    }
}

// MARK: - UICollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.onViewModelDidSelectItem(at: indexPath)
    }
}

// MARK: - HomeViewModel Delegate

extension HomeViewController: HomeViewModelDelegate {
    func notifyProcessSections(sections: [HomeLayoutSectionModel], animated: Bool) {
        reloadData(sections: sections, animated: animated)
    }
    
    func notifySuccessFetchSections() {
        errorView.removeFromSuperview()
    }
    
    func notifyFailedFetchSections(error: Error) {
        if errorView.superview == nil {
            view.addSubview(self.errorView)
            errorView.addMessage(error.localizedDescription)
        } else {
            errorView.stopActivityIndicator()
        }
    }
    
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol) {
        let detailVC: DetailViewController = DetailViewController(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ErrorView Delegate

extension HomeViewController: ErrorViewDelegate {
    func retryErrorButtonOnTapped() {
        homeViewModel.onViewModelReloadData()
    }
}
