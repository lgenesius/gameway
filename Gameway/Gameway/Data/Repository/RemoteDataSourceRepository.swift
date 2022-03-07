//
//  RemoteDataSourceRepository.swift
//  Gameway
//
//  Created by Luis Genesius on 26/01/22.
//

import Foundation
import Combine

final class RemoteDataSourceRepository: RemoteDataSourceRepositoryProtocol {
    var remoteDataSource: RemoteDataSourceProtocol
    
    init(dataSource remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchGiveaways() -> AnyPublisher<[Giveaway], Error> {
        return remoteDataSource.fetchGiveaways(params: nil)
    }
    
    func fetchRecentGiveaways() -> AnyPublisher<[Giveaway], Error> {
        return remoteDataSource.fetchGiveaways(params: ["sort-by": "date"])
    }
    
    func fetchWorth() -> AnyPublisher<Worth, Error> {
        return remoteDataSource.fetchWorth(params: nil)
    }
}
