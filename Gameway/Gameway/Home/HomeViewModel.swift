//
//  SectionViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation
import Combine
import UIKit

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    
    func onViewModelDidLoad()
    func onViewModelReloadData()
    func onViewModelDidSelectItem(at indexPath: IndexPath)
    func onViewModelSelectLayoutSection(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection
}

protocol HomeViewModelDelegate: NSObject {
    func notifyProcessSections(sections: [HomeSectionModel])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol)
}

final class HomeViewModel {
    
    // MARK: - Properties
    
    weak var delegate: HomeViewModelDelegate?
    
    @Published private var sections = [HomeSectionModel]()
    
    private var anyCancellable = Set<AnyCancellable>()
    private let gameType: String = "Game"
    
    private let dependency: HomeViewModelDependency
    
    // MARK: - Initialization
    
    init(
        dependency: HomeViewModelDependency = HomeViewModelDependency()
    ) {
        self.dependency = dependency
    }
    
    deinit {
        anyCancellable.removeAll()
    }
    
    // MARK: - Fetch Giveaways
    
    private func fetchRecentGiveaways() {
        dependency.remoteDataSourceRepository.fetchRecentGiveaways()
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .sink { [weak self] (completion: Subscribers.Completion<Error>) in
                guard let self: HomeViewModel = self else { return }
                
                switch completion {
                case .finished:
                    self.delegate?.notifySuccessFetchSections()
                case .failure(let error):
                    self.delegate?.notifyFailedFetchSections(error: error)
                }
            } receiveValue: { [weak self] giveaways in
                guard let self = self, !giveaways.isEmpty else { return }
                self.sections = []
                self.filterToGetSoonExpiredGiveaways(giveaways: giveaways)
                self.filterToGetRecentGiveaways(giveaways: giveaways)
                self.filterToGetValuableGiveaways(giveaways: giveaways)
                
                self.delegate?.notifyProcessSections(sections: self.sections)
            }
            .store(in: &anyCancellable)
    }
    
    // MARK: - Filter Giveaways
    
    private func filterToGetSoonExpiredGiveaways(giveaways: [Giveaway]) {
        let soonExpiredItems: [Item] = dependency.giveawaysFilterProvider.filterToGetSoonExpiredGiveaways(giveaways).map {
            return Item(id: UUID().uuidString, giveaway: $0)
        }
        
        if !soonExpiredItems.isEmpty {
            let soonExpiredSection: HomeSectionModel = HomeSectionModel(
                id: UUID().uuidString,
                type: .soonExpired,
                title: "Soon Expired Giveaways",
                subtitle: "Games, DLC, Loots, Early Access and Other",
                items: soonExpiredItems
            )
            sections.append(soonExpiredSection)
        }
    }
    
    private func filterToGetRecentGiveaways(giveaways: [Giveaway]) {
        let recentGameItems: [Item] = dependency.giveawaysFilterProvider.filterToGetRecentGiveaways(
            giveaways,
            type: DirectGiveawayType.game
        ).map { Item(id: UUID().uuidString, giveaway: $0) }
        
        let recentOtherItems: [Item] = dependency.giveawaysFilterProvider.filterToGetRecentGiveaways(
            giveaways,
            type: ConditionalGiveawayType.otherThanGame
        ).map { Item(id: UUID().uuidString, giveaway: $0) }
        
        if !recentGameItems.isEmpty {
            let gameRecentSection: HomeSectionModel = HomeSectionModel(
                id: UUID().uuidString,
                type: .recent,
                title: "Recent Game Giveaways",
                subtitle: "Only Games",
                items: recentGameItems
            )
            sections.append(gameRecentSection)
        }
        
        if !recentOtherItems.isEmpty {
            let otherRecentSection: HomeSectionModel = HomeSectionModel(
                id: UUID().uuidString,
                type: .recent,
                title: "Recent Other Giveaways",
                subtitle: "Containing DLC, Loots, Early Access and Other",
                items: recentOtherItems
            )
            sections.append(otherRecentSection)
        }
    }
    
    private func filterToGetValuableGiveaways(giveaways: [Giveaway]) {
        let valuableItems: [Item] = dependency.giveawaysFilterProvider.filterToGetValueableGiveaways(giveaways).map {
            return Item(id: UUID().uuidString, giveaway: $0)
        }
        
        if !valuableItems.isEmpty {
            let valuableSection: HomeSectionModel = HomeSectionModel(
                id: UUID().uuidString,
                type: .valuable,
                title: "Most Valuable Giveaways",
                subtitle: "Games, DLC, Loots, Early Access and Other",
                items: valuableItems
            )
            sections.append(valuableSection)
        }
    }
}

// MARK: - HomeViewModel Protocol

extension HomeViewModel: HomeViewModelProtocol {
    func onViewModelDidLoad() {
        fetchRecentGiveaways()
    }
    
    func onViewModelReloadData() {
        fetchRecentGiveaways()
    }
    
    func onViewModelDidSelectItem(at indexPath: IndexPath) {
        guard indexPath.section < sections.count else { return }
        
        let section: HomeSectionModel = sections[indexPath.section]
        guard indexPath.row < section.items.count else { return }
        
        let item: Item = section.items[indexPath.row]
        
        let detailVM: DetailViewModelProtocol = DetailViewModel(giveaway: item.giveaway)
        delegate?.notifyNavigateToDetailPage(with: detailVM)
    }
    
    func onViewModelSelectLayoutSection(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        var layoutSectionType: HomeCollectionLayoutSectionType = .card
        var sectionHeaderType: HomeCollectionLayoutSectionHeaderType?
        
        guard sectionIndex < sections.count
        else {
            return dependency.layoutSectionProvider.provideCollectionLayoutSection(
                type: layoutSectionType,
                sectionHeaderType: sectionHeaderType
            )
        }
        
        if sections[sectionIndex].type == .loading {
            layoutSectionType = .card
            sectionHeaderType = nil
        }
        else {
            layoutSectionType = .carousel
            sectionHeaderType = .default
        }
        
        return dependency.layoutSectionProvider.provideCollectionLayoutSection(
            type: layoutSectionType,
            sectionHeaderType: sectionHeaderType
        )
    }
}
