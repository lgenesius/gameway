//
//  GiveawayViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 15/02/22.
//

import Foundation
import Combine

final class GiveawayViewModel {
    @Published var giveaways = [Giveaway]()
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    func fetchGiveaways(completion: @escaping () -> Void) {
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
                self?.giveaways = giveaways
                completion()
            }
            .store(in: &anyCancellable)
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}
