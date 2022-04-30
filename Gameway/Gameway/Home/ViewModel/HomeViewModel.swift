//
//  SectionViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    
    func onViewModelDidLoad()
    func refetchSections()
}

protocol HomeViewModelDelegate {
    func processSectionsFromViewModel(sections: [Section])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
}

final class HomeViewModel: HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate?
    
    @Published private var sections = [Section]()
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    private let gameType: String = "Game"
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    func onViewModelDidLoad() {
        fetchRecentGiveaways()
    }
    
    func refetchSections() {
        sections = []
        fetchRecentGiveaways()
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
                self.filterToGetPopularGiveaways(giveaways: giveaways)
                self.filterToGetRecentGiveaways(giveaways: giveaways)
                self.filterToGetValuableGiveaways(giveaways: giveaways)
                
                self.delegate?.processSectionsFromViewModel(sections: self.sections)
            }
            .store(in: &anyCancellable)
    }
    
    private func filterToGetPopularGiveaways(giveaways: [Giveaway]) {
        let sortedPopularGiveaways: [Giveaway] = giveaways.sorted(by: { $0.users > $1.users })
        let popularItems: [Item] = sortedPopularGiveaways.map { giveaway -> Item in
            return Item(id: UUID().uuidString, giveaway: giveaway)
        }
        
        if !popularItems.isEmpty {
            let popularSection: Section = Section(id: 1,
                                         type: .popular,
                                         title: "Current Popular Giveaways",
                                         subtitle: "Games, DLC, Loots, Early Access and Other",
                                         items: popularItems)
            sections.append(popularSection)
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
