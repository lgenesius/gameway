//
//  GiveawayViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 15/02/22.
//

import Foundation
import Combine

protocol GiveawayViewModelProtocol {
    var delegate: GiveawayViewModelDelegate? { get set }
    var isFetched: Bool { get }
    
    func onViewModelGetGiveaways() -> [Giveaway]
    func onViewModelDidLoad()
    func onViewModelReloadData()
}

protocol GiveawayViewModelDelegate {
    func processGiveawaysFromViewModel(giveaways: [Giveaway])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
}

final class GiveawayViewModel {
    var delegate: GiveawayViewModelDelegate?
    
    @Published private var giveaways = [Giveaway]()
    @Published private var worth: Worth?
    
    private(set) var isFetched: Bool
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
        isFetched = false
    }
    
    private func fetchGiveaways() {
        isFetched = false
        
        remoteDataSourceRepository.fetchRecentGiveaways()
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .sink { [weak self] (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .finished:
                    self?.delegate?.notifySuccessFetchSections()
                case .failure(let error):
                    self?.delegate?.notifyFailedFetchSections(error: error)
                }
            } receiveValue: { [weak self] giveaways in
                self?.giveaways = giveaways
                self?.isFetched = true
                self?.delegate?.processGiveawaysFromViewModel(giveaways: giveaways)
            }
            .store(in: &anyCancellable)
    }
    
    private func fetchWorth() {
        remoteDataSourceRepository.fetchWorth()
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] worth in
                self?.worth = worth
            }
            .store(in: &anyCancellable)
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}

// MARK: - GiveawayViewModel Protocol

extension GiveawayViewModel: GiveawayViewModelProtocol {
    func onViewModelGetGiveaways() -> [Giveaway] {
        return giveaways
    }
    
    func onViewModelDidLoad() {
        fetchGiveaways()
    }
    
    func onViewModelReloadData() {
        fetchGiveaways()
    }
    
    
}
