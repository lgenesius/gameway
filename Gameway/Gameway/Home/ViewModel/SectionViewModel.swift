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
        fetchPopularGiveaways()
        fetchRecentGiveaways()
        fetchValueGiveaways()
    }
    
    private func fetchPopularGiveaways() {
        NetworkManager.shared.fetchGiveaways(params: ["sort-by": "popularity"])
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Done")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] giveaways in
                guard !giveaways.isEmpty else { return }
                let newSection = Section(id: 1, type: "Popular Giveaways", title: "Most Popular Giveaways", subtitle: "", giveaways: giveaways)
                self?.sections.append(newSection)
            }
            .store(in: &anyCancellable)
    }
    
    private func fetchRecentGiveaways() {
        NetworkManager.shared.fetchGiveaways(params: ["sort-by": "date"])
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
                let newSection = Section(id: 2, type: "Recent Giveaways", title: "Most Recent Giveaways", subtitle: "", giveaways: giveaways)
                self?.sections.append(newSection)
            }
            .store(in: &anyCancellable)
    }
    
    private func fetchValueGiveaways() {
        NetworkManager.shared.fetchGiveaways(params: ["sort-by": "value"])
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
                let newSection = Section(id: 3, type: "Value Giveaways", title: "Most Valuable Giveaways", subtitle: "", giveaways: giveaways)
                self?.sections.append(newSection)
            }
            .store(in: &anyCancellable)
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}
