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
    func onViewModelGetWorth() -> Worth?
    func onViewModelDidLoad()
    func onViewModelReloadData()
    func onViewModelLoadMore()
    func onViewModelCanPaginate() -> Bool
}

protocol GiveawayViewModelDelegate {
    func processGiveawaysFromViewModel(giveaways: [Giveaway])
    func processWorthFromViewModel(worth: Worth)
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
}

final class GiveawayViewModel {
    var delegate: GiveawayViewModelDelegate?
    
    private var giveawaysContainer = [Giveaway]()
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
                    break
                case .failure(let error):
                    self?.delegate?.notifyFailedFetchSections(error: error)
                }
            } receiveValue: { [weak self] giveaways in
                self?.giveawaysContainer = giveaways
                self?.giveaways.append(contentsOf: giveaways[0..<10])
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
                self?.delegate?.processWorthFromViewModel(worth: worth)
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
    
    func onViewModelGetWorth() -> Worth? {
        return worth
    }
    
    func onViewModelDidLoad() {
        fetchWorth()
        fetchGiveaways()
    }
    
    func onViewModelReloadData() {
        fetchWorth()
        fetchGiveaways()
    }
    
    func onViewModelLoadMore() {
        guard giveawaysContainer.count > giveaways.count else { return }
        giveaways.append(contentsOf: giveawaysContainer[giveaways.count + 1...giveaways.count + 10])
        delegate?.processGiveawaysFromViewModel(giveaways: giveaways)
    }
    
    func onViewModelCanPaginate() -> Bool {
        return giveawaysContainer.count > giveaways.count
    }
}
