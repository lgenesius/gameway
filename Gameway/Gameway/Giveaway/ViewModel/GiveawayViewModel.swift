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
    
    func onViewModelGetGiveaways() -> [Giveaway]
    func onViewModelGetWorth() -> Worth?
    func onViewModelDidLoad()
    func onViewModelReloadData()
    func onViewModelLoadMore()
    func onViewModelCanPaginate() -> Bool
    func onViewModelSetFilterSheet()
    func onViewModelProcessFilter(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    )
}

protocol GiveawayViewModelDelegate: NSObject {
    func processGiveawaysFromViewModel(giveaways: [Giveaway])
    func processWorthFromViewModel(worth: Worth)
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
    func setFilterSheetView(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    )
}

final class GiveawayViewModel {
    weak var delegate: GiveawayViewModelDelegate?
    
    private var platformFilters: [Filter] = [
        Filter(name: "PC", code: "pc", type: .platform),
        Filter(name: "Steam", code: "steam", type: .platform),
        Filter(name: "Epic Games Store", code: "epic-games-store", type: .platform),
        Filter(name: "Ubisoft", code: "ubisoft", type: .platform),
        Filter(name: "GOG", code: "gog", type: .platform),
        Filter(name: "Itch.io", code: "itchio", type: .platform),
        Filter(name: "PS4", code: "ps4", type: .platform),
        Filter(name: "PS5", code: "ps5", type: .platform),
        Filter(name: "Xbox One", code: "xbox-one", type: .platform),
        Filter(name: "Xbox Series XS", code: "xbox-series-xs", type: .platform),
        Filter(name: "Switch", code: "switch", type: .platform),
        Filter(name: "Android", code: "android", type: .platform),
        Filter(name: "iOS", code: "ios", type: .platform),
        Filter(name: "VR", code: "vr", type: .platform),
        Filter(name: "Battle.net", code: "battlenet", type: .platform),
        Filter(name: "Origin", code: "origin", type: .platform),
        Filter(name: "DRM Free", code: "drm-free", type: .platform),
        Filter(name: "Xbox 360", code: "xbox-360", type: .platform)
    ]

    private var typeFilters: [Filter] = [
        Filter(name: "Game", code: "game", type: .type),
        Filter(name: "Loot", code: "loot", type: .type),
        Filter(name: "Beta", code: "beta", type: .type)
    ]

    private var sortFilters: [Filter] = [
        Filter(name: "Date", code: "date", type: .sort),
        Filter(name: "Value", code: "value", type: .sort),
        Filter(name: "Popularity", code: "popularity", type: .sort)
    ]
    
    private var giveawaysContainer = [Giveaway]()
    @Published private var giveaways = [Giveaway]()
    @Published private var worth: Worth?
    
    private var remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    
    private var anyCancellable = Set<AnyCancellable>()
    
    init(repository remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
    }
    
    private func fetchRecentGiveaways() {
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
                
                let maxItemSize: Int = giveaways.count < 10 ? giveaways.count : 10
                self?.giveaways = []
                self?.giveaways.append(contentsOf: giveaways[0..<maxItemSize])
                self?.setWorth()
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
    
    private func fetchFilterIfNeeded() {
        var dictionary: [String : String] = [:]
        
        let platformQuery: String = getQuery(filters: platformFilters)
        if !platformQuery.isEmpty {
            dictionary["platform"] = platformQuery
        }
        
        let typeQuery: String = getQuery(filters: typeFilters)
        if !typeQuery.isEmpty {
            dictionary["type"] = typeQuery
        }
        
        let sortQuery: String = getQuery(filters: sortFilters)
        if !sortQuery.isEmpty {
            dictionary["sort-by"] = sortQuery
        }
        
        if !dictionary.isEmpty && (!platformQuery.isEmpty || !typeQuery.isEmpty) {
            remoteDataSourceRepository.fetchFilter(params: dictionary)
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
                    let maxItemSize: Int = giveaways.count < 10 ? giveaways.count : 10
                    self?.giveaways = []
                    self?.giveaways.append(contentsOf: giveaways[0..<maxItemSize])
                    self?.setWorth()
                    self?.delegate?.processGiveawaysFromViewModel(giveaways: giveaways)
                }
                .store(in: &anyCancellable)
        } else {
            fetchRecentGiveaways()
        }
    }
    
    private func setWorth() {
        let activeGiveawayNumber: Int = giveawaysContainer.count
        let worthEstimation: Double = giveawaysContainer.reduce(0.0) { result, giveaway in
            //Drop the dollar sign from string
            let removedFirstCharString: String = String(giveaway.worth.dropFirst())
            if let worth: Double = Double(removedFirstCharString) {
                return result + worth
            }
            return result
        }
        let tempWorth: Worth = Worth(activeGiveawaysNumber: activeGiveawayNumber, worthEstimationUSD: String(format: "%.2f", worthEstimation))
        worth = tempWorth
        delegate?.processWorthFromViewModel(worth: tempWorth)
    }
    
    private func getQuery(filters: [Filter]) -> String {
        var queryResult: String = ""
        
        queryResult = filters.reduce("", { result, filter in
            if filter.isSelected {
                if !result.isEmpty {
                    return result + ".\(filter.code)"
                } else {
                    return filter.code
                }
            }
            return result
        })
        
        return queryResult
    }
    
    deinit {
        anyCancellable.removeAll()
    }
}

// MARK: - GiveawayViewModel Protocol

extension GiveawayViewModel: GiveawayViewModelProtocol {
    func onViewModelProcessFilter(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    ) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        self.platformFilters = platformFilters.map({
            userDefaults.set($0.isSelected, forKey: "user-defaults-\($0.code)")
            return $0
        })
        
        self.typeFilters = typeFilters.map({
            userDefaults.set($0.isSelected, forKey: "user-defaults-\($0.code)")
            return $0
        })
        
        self.sortFilters = sortFilters.map({
            userDefaults.set($0.isSelected, forKey: "user-defaults-\($0.code)")
            return $0
        })
        
        fetchFilterIfNeeded()
    }
    
    func onViewModelGetGiveaways() -> [Giveaway] {
        return giveaways
    }
    
    func onViewModelGetWorth() -> Worth? {
        return worth
    }
    
    func onViewModelDidLoad() {
        fetchFilterIfNeeded()
    }
    
    func onViewModelReloadData() {
        fetchFilterIfNeeded()
    }
    
    func onViewModelLoadMore() {
        guard giveawaysContainer.count > giveaways.count else { return }
        let maxItemSize: Int = giveaways.count + 10 < giveawaysContainer.count ? giveaways.count + 10 : giveawaysContainer.count
        giveaways.append(contentsOf: giveawaysContainer[giveaways.count..<maxItemSize])
        delegate?.processGiveawaysFromViewModel(giveaways: giveaways)
    }
    
    func onViewModelCanPaginate() -> Bool {
        return giveawaysContainer.count > giveaways.count
    }
    
    func onViewModelSetFilterSheet() {
        delegate?.setFilterSheetView(
            platformFilters: platformFilters,
            typeFilters: typeFilters,
            sortFilters: sortFilters
        )
    }
}
