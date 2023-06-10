//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainDarkBlue
        collectionView.delegate = self
        collectionView.register(
            HomeCardCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCardCollectionViewCell.identifier
        )
        collectionView.register(
            HomeSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeader.reuseIdentifier
        )
        return collectionView
    }()
    
    private lazy var skeletonLoaderTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .mainDarkBlue
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var errorView: ErrorView = {
        let errorView: ErrorView = ErrorView(frame: view.bounds)
        errorView.delegate = self
        return errorView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<HomeSectionModel, Item> = {
        let dataSource: UICollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<HomeSectionModel, Item>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                return self?.configure(
                    HomeCardCollectionViewCell.self,
                    with: item,
                    for: indexPath
                )
            }
        )
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader: HomeSectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeSectionHeader.reuseIdentifier,
                for: indexPath
            ) as? HomeSectionHeader else {
                return nil
            }
            
            guard let firstItem: Item = self?.dataSource.itemIdentifier(for: indexPath) else { return nil }
            guard let section: HomeSectionModel = self?.dataSource.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            sectionHeader.setTitleText(
                title: section.title,
                subtitle: section.subtitle
            )
            return sectionHeader
        }
        return dataSource
    }()
    
    init(viewModel homeViewModel: HomeViewModelProtocol) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setCurrentViewInterface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewSettings()
        setTableViewSettings()
        homeViewModel.onViewModelDidLoad()
    }
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        view.backgroundColor = .mainDarkBlue
    }
    
    private func setTableViewSettings() {
        view.addSubview(skeletonLoaderTableView)
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
    private func configure<T: ConfigCell>(
        _ cellType: T.Type,
        with item: Item,
        for indexPath: IndexPath
    ) -> T {
        guard let cell: T = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError()
        }
        cell.configure(with: item as? T.Request)
        return cell
    }
    
    private func reloadData(sections: [HomeSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionModel, Item>()
        snapshot.appendSections(sections)
        
        for section: HomeSectionModel in sections {
            switch section.type {
            case .popular:
                snapshot.appendItems(Array(section.items.prefix(8)), toSection: section)
            case .recent:
                snapshot.appendItems(Array(section.items.prefix(10)), toSection: section)
            case .valuable:
                snapshot.appendItems(Array(section.items.prefix(10)), toSection: section)
            case .soonExpired:
                snapshot.appendItems(Array(section.items.prefix(10)), toSection: section)
            case .loading:
                snapshot.appendItems(section.items, toSection: section)
            }
        }
        
        dataSource.apply(snapshot)
    }
}

// MARK: - Compositional Layout

extension HomeViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            return self.homeViewModel.onViewModelSelectLayoutSection(
                sectionIndex: sectionIndex,
                layoutEnvironment: layoutEnvironment
            )
        }
        
        let config: UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        layout.configuration = config
        return layout
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
        390
    }
}

// MARK: - UICollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.skeletonLoaderTableView.superview == nil else { return }
        homeViewModel.onViewModelDidSelectItem(at: indexPath)
    }
}

// MARK: - HomeViewModel Delegate

extension HomeViewController: HomeViewModelDelegate {
    func notifyProcessSections(sections: [HomeSectionModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let self: HomeViewController = self else { return }
            
            if self.skeletonLoaderTableView.superview != nil {
                self.skeletonLoaderTableView.removeFromSuperview()
            }
            
            self.reloadData(sections: sections)
        }
    }
    
    func notifySuccessFetchSections() {
        DispatchQueue.main.async { [weak self] in
            guard let self: HomeViewController = self else { return }
            
            if self.errorView.superview != nil {
                self.errorView.removeFromSuperview()
            }
        }
    }
    
    func notifyFailedFetchSections(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self: HomeViewController = self else { return }
            
            if self.errorView.superview == nil {
                self.view.addSubview(self.errorView)
                self.errorView.addMessage(error.localizedDescription)
            } else {
                self.errorView.stopActivityIndicator()
            }
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
