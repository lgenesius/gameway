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
    
    init(dataSource remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchRecentGiveaways() -> AnyPublisher<[Giveaway], Error> {
        return remoteDataSource.fetchGiveaways(params: ["sort-by": "date"])
    }
}
