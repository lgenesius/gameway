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
    func onViewModelReturnSections() -> [HomeLayoutSectionModel]
}

protocol HomeViewModelDelegate: NSObject {
    func notifyProcessSections(sections: [HomeLayoutSectionModel])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol)
}

final class HomeViewModel {
    
    // MARK: - Properties
    
    weak var delegate: HomeViewModelDelegate?
    
    @Published private var sections = [HomeLayoutSectionModel]()
    
    private var anyCancellable = Set<AnyCancellable>()
    
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
    
    // MARK: - Loading
    
    private func startLoading() {
        sections = []
        
        let loadingSectionModel: LoadingLayoutSectionModel = LoadingLayoutSectionModel(items: [
            LoadingLayoutItemModel(),
            LoadingLayoutItemModel()
        ])
        sections.append(loadingSectionModel)
        
        delegate?.notifyProcessSections(sections: sections)
    }
    
    // MARK: - Fetch Giveaways
    
    private func fetchRecentGiveaways() {
        startLoading()
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
        let soonExpiredItems: [CarouselLayoutItemModel] = dependency.giveawaysFilterProvider.filterToGetSoonExpiredGiveaways(giveaways).map {
            return CarouselLayoutItemModel(giveaway: $0)
        }
        
        if !soonExpiredItems.isEmpty {
            let carouselSectionModel: CarouselLayoutSectionModel = CarouselLayoutSectionModel(items: soonExpiredItems)
            carouselSectionModel.title = "Soon Expired Giveaways"
            carouselSectionModel.subtitle = "Games, DLC, Loots, Early Access and Other"
            sections.append(carouselSectionModel)
        }
    }
    
    private func filterToGetRecentGiveaways(giveaways: [Giveaway]) {
        let recentGameItems: [CarouselLayoutItemModel] = dependency.giveawaysFilterProvider.filterToGetRecentGiveaways(
            giveaways,
            type: DirectGiveawayType.game
        ).map { CarouselLayoutItemModel(giveaway: $0) }
        
        let recentOtherItems: [CarouselLayoutItemModel] = dependency.giveawaysFilterProvider.filterToGetRecentGiveaways(
            giveaways,
            type: ConditionalGiveawayType.otherThanGame
        ).map { CarouselLayoutItemModel(giveaway: $0) }
        
        if !recentGameItems.isEmpty {
            let carouselSectionModel: CarouselLayoutSectionModel = CarouselLayoutSectionModel(items: recentGameItems)
            carouselSectionModel.title = "Recent Game Giveaways"
            carouselSectionModel.subtitle = "Only Games"
            sections.append(carouselSectionModel)
        }
        
        if !recentOtherItems.isEmpty {
            let carouselSectionModel: CarouselLayoutSectionModel = CarouselLayoutSectionModel(items: recentOtherItems)
            carouselSectionModel.title = "Recent Other Giveaways"
            carouselSectionModel.subtitle = "Containing DLC, Loots, Early Access and Other"
            sections.append(carouselSectionModel)
        }
    }
    
    private func filterToGetValuableGiveaways(giveaways: [Giveaway]) {
        let valuableItems: [CarouselLayoutItemModel] = dependency.giveawaysFilterProvider.filterToGetValueableGiveaways(giveaways).map {
            return CarouselLayoutItemModel(giveaway: $0)
        }
        
        if !valuableItems.isEmpty {
            let carouselSectionModel: CarouselLayoutSectionModel = CarouselLayoutSectionModel(items: valuableItems)
            carouselSectionModel.title = "Most Valuable Giveaways"
            carouselSectionModel.subtitle = "Games, DLC, Loots, Early Access and Other"
            sections.append(carouselSectionModel)
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
        
        let section: HomeLayoutSectionModel = sections[indexPath.section]
        
        if let carouselSection: CarouselLayoutSectionModel = section as? CarouselLayoutSectionModel {
            guard indexPath.row < carouselSection.carouselItems.count else { return }
            let carouselItem: CarouselLayoutItemModel = carouselSection.carouselItems[indexPath.row]
            
            let detailVM: DetailViewModelProtocol = DetailViewModel(giveaway: carouselItem.giveaway)
            delegate?.notifyNavigateToDetailPage(with: detailVM)
        }
    }
    
    func onViewModelReturnSections() -> [HomeLayoutSectionModel] {
        return sections
    }
}
