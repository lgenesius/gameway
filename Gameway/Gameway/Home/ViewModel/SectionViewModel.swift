//
//  SectionViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation
import Combine

final class SectionViewModel {
    @Published var sections = [Section]()
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    private let gameType = "Full Game"
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    func fetchSections(completion: @escaping () -> Void) {
        fetchRecentGiveaways(completion: completion)
    }
    
    private func fetchRecentGiveaways(completion: @escaping () -> Void) {
        remoteDataSourceRepository.fetchRecentGiveaways()
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] giveaways in
                guard !giveaways.isEmpty else { return }

                self?.filterToGetPopularGiveaways(giveaways: giveaways)
                
                self?.filterToGetRecentGiveaways(giveaways: giveaways)

                self?.filterToGetValuableGiveaways(giveaways: giveaways)
                
                completion()
            }
            .store(in: &anyCancellable)
    }
    
    private func filterToGetPopularGiveaways(giveaways: [Giveaway]) {
        let sortedPopularGiveaways = giveaways.sorted(by: { $0.users > $1.users })
        let popularItems = sortedPopularGiveaways.map { giveaway -> Item in
            return Item(id: UUID().uuidString, giveaway: giveaway)
        }
        
        if !popularItems.isEmpty {
            let popularSection = Section(id: 1, type: .popular, title: "Current Popular Giveaways", subtitle: "Games, DLC, Loots, Early Access and Other", items: popularItems)
            sections.append(popularSection)
        }
    }
    
    private func filterToGetRecentGiveaways(giveaways: [Giveaway]) {
        var recentOtherItems = [Item]()
        var recentGameItems = [Item]()
        
        for giveaway in giveaways {
            if giveaway.type == gameType {
                recentGameItems.append(Item(id: UUID().uuidString, giveaway: giveaway))
            } else {
                recentOtherItems.append(Item(id: UUID().uuidString, giveaway: giveaway))
            }
        }
        
        if !recentGameItems.isEmpty {
            let gameRecentSection = Section(id: 3, type: .recent, title: "Recent Game Giveaways", subtitle: "Only Games", items: recentGameItems)
            sections.append(gameRecentSection)
        }
        
        if !recentOtherItems.isEmpty {
            let otherRecentSection = Section(id: 4, type: .recent, title: "Recent Other Giveaways", subtitle: "Containing DLC, Loots, Early Access and Other", items: recentOtherItems)
            sections.append(otherRecentSection)
        }
    }
    
    private func filterToGetValuableGiveaways(giveaways: [Giveaway]) {
        let valuableGiveaways = giveaways.sorted(by: { Double($0.worth.dropFirst()) ?? 0.0 > Double($1.worth.dropFirst()) ?? 0.0 })
        let valuableItems = valuableGiveaways.map { giveaway -> Item in
            return Item(id: UUID().uuidString, giveaway: giveaway)
        }
        
        if !valuableItems.isEmpty {
            let valuableSection = Section(id: 5, type: .valuable, title: "Most Valuable Giveaways", subtitle: "Games, DLC, Loots, Early Access and Other", items: valuableItems)
            sections.append(valuableSection)
        }
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}
