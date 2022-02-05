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
    
    var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    private var anyCancellable = Set<AnyCancellable>()
    
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

                let popularGiveaways = giveaways.sorted(by: { $0.users > $1.users })
                let newPopularItems = popularGiveaways.map { Item(id: UUID().uuidString, giveaway: $0) }
                let newPopularSection = Section(id: 1, type: "Popular Giveaways", title: "Most Popular Giveaways", subtitle: "", items: newPopularItems)
                self?.sections.append(newPopularSection)

                let newRecentItems = giveaways.map { Item(id: UUID().uuidString, giveaway: $0) }
                let newRecentSection = Section(id: 2, type: "Recent Giveaways", title: "Most Recent Giveaways", subtitle: "", items: newRecentItems)
                self?.sections.append(newRecentSection)

                let valuableGiveaways = giveaways.sorted(by: { Double($0.worth.dropFirst()) ?? 0.0 > Double($1.worth.dropFirst()) ?? 0.0 })
                let newValuableItems = valuableGiveaways.map { Item(id: UUID().uuidString, giveaway: $0) }
                let newValuableSection = Section(id: 3, type: "Valuable Giveaways", title: "Most Valuable Giveaways", subtitle: "", items: newValuableItems)
                self?.sections.append(newValuableSection)
                
                completion()
            }
            .store(in: &anyCancellable)
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}
