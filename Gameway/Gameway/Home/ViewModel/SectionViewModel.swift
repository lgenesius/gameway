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
    
    private var anyCancellable = Set<AnyCancellable>()
    
    func fetchSections() {
        fetchRecentGiveaways()
    }
    
    private func fetchRecentGiveaways() {
//        RemoteDataSource.shared.fetchGiveaways(params: ["sort-by": "date"])
//            .receive(on: DispatchQueue.main)
//            .map { $0 }
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] giveaways in
//                guard !giveaways.isEmpty else { return }
//
//                let popularGiveaways = giveaways.sorted(by: { $0.users > $1.users })
//                let newPopularSection = Section(id: 1, type: "Popular Giveaways", title: "Most Popular Giveaways", subtitle: "", giveaways: popularGiveaways)
//                self?.sections.append(newPopularSection)
//
//                let newRecentSection = Section(id: 2, type: "Recent Giveaways", title: "Most Recent Giveaways", subtitle: "", giveaways: giveaways)
//                self?.sections.append(newRecentSection)
//
//                let valuableGiveaways = giveaways.sorted(by: { Double($0.worth.dropFirst())! > Double($1.worth.dropFirst())! })
//                let newValuableSection = Section(id: 3, type: "Valuable Giveaways", title: "Most Valuable Giveaways", subtitle: "", giveaways: valuableGiveaways)
//                self?.sections.append(newValuableSection)
//            }
//            .store(in: &anyCancellable)
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}
