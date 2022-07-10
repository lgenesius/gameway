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
}

protocol HomeViewModelDelegate: NSObject {
    func notifyProcessSections(sections: [Section])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol)
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    
    @Published private var sections = [Section]()
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    private let gameType: String = "Game"
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    private func fetchRecentGiveaways() {
        remoteDataSourceRepository.fetchRecentGiveaways()
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
    
    private func filterToGetSoonExpiredGiveaways(giveaways: [Giveaway]) {
        let sortedSoonExpiredGiveaways: [Giveaway] = giveaways.sorted(by: {
            let previousGiveawayEndDate: Date? = DateHelper.convertStringToDate($0.endDate)
            let nextGiveawayEndDate: Date? = DateHelper.convertStringToDate($1.endDate)
            
            guard let previousEndDate: Date = previousGiveawayEndDate,
                  let previousDayDiff = DateHelper.getDayDifference(from: Date(), to: previousEndDate),
            previousDayDiff >= 0 else {
                return false
            }
            guard let nextEndDate: Date = nextGiveawayEndDate,
                  let nextDayDiff = DateHelper.getDayDifference(from: Date(), to: nextEndDate),
                  nextDayDiff >= 0
            else { return true }

            return previousEndDate < nextEndDate
        })
        
        let soonExpiredItems: [Item] = sortedSoonExpiredGiveaways.map { giveaway -> Item in
            return Item(id: UUID().uuidString, giveaway: giveaway)
        }
        
        if !soonExpiredItems.isEmpty {
            let soonExpiredSection: Section = Section(id: 1,
                                                      type: .soonExpired,
                                                      title: "Soon Expired Giveaways",
                                                      subtitle: "Games, DLC, Loots, Early Access and Other",
                                                      items: soonExpiredItems)
            sections.append(soonExpiredSection)
        }
    }
    
    private func filterToGetRecentGiveaways(giveaways: [Giveaway]) {
        var recentOtherItems = [Item]()
        var recentGameItems = [Item]()
        
        for giveaway: Giveaway in giveaways {
            if giveaway.type == gameType {
                recentGameItems.append(Item(id: UUID().uuidString, giveaway: giveaway))
            } else {
                recentOtherItems.append(Item(id: UUID().uuidString, giveaway: giveaway))
            }
        }
        
        if !recentGameItems.isEmpty {
            let gameRecentSection: Section = Section(id: 2,
                                            type: .recent,
                                            title: "Recent Game Giveaways",
                                            subtitle: "Only Games",
                                            items: recentGameItems)
            sections.append(gameRecentSection)
        }
        
        if !recentOtherItems.isEmpty {
            let otherRecentSection: Section = Section(id: 3,
                                             type: .recent,
                                             title: "Recent Other Giveaways",
                                             subtitle: "Containing DLC, Loots, Early Access and Other",
                                             items: recentOtherItems)
            sections.append(otherRecentSection)
        }
    }
    
    private func filterToGetValuableGiveaways(giveaways: [Giveaway]) {
        let valuableGiveaways: [Giveaway] = giveaways.sorted(by: { Double($0.worth.dropFirst()) ?? 0.0 > Double($1.worth.dropFirst()) ?? 0.0 })
        let valuableItems: [Item] = valuableGiveaways.map { giveaway -> Item in
            return Item(id: UUID().uuidString, giveaway: giveaway)
        }
        
        if !valuableItems.isEmpty {
            let valuableSection: Section = Section(id: 4,
                                          type: .valuable,
                                          title: "Most Valuable Giveaways",
                                          subtitle: "Games, DLC, Loots, Early Access and Other",
                                          items: valuableItems)
            sections.append(valuableSection)
        }
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}

// MARK: - Observers

extension HomeViewModel {
    private func addObservers() {
        let notificationCenter: NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onViewModelWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc
    private func onViewModelWillEnterForegroundNotification() {
        onViewModelReloadData()
    }
}

// MARK: - HomeViewModel Protocol

extension HomeViewModel: HomeViewModelProtocol {
    func onViewModelDidLoad() {
        addObservers()
        fetchRecentGiveaways()
    }
    
    func onViewModelReloadData() {
        fetchRecentGiveaways()
    }
    
    func onViewModelDidSelectItem(at indexPath: IndexPath) {
        guard indexPath.section < sections.count else { return }
        
        let section: Section = sections[indexPath.section]
        guard indexPath.row < section.items.count else { return }
        
        let item: Item = section.items[indexPath.row]
        
        let detailVM: DetailViewModelProtocol = DetailViewModel(giveaway: item.giveaway)
        delegate?.notifyNavigateToDetailPage(with: detailVM)
    }
}
