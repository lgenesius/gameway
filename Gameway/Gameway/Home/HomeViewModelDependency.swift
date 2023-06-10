//
//  HomeViewModelDependency.swift
//  Gameway
//
//  Created by Luis Genesius on 10/06/23.
//

import Foundation

final class HomeViewModelDependency {
    let remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol
    let giveawaysFilterProvider: HomeGiveawayFilterProviderProtocol
    let layoutSectionProvider: HomeCollectionLayoutSectionProviderProtocol
    
    init(
        remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol = RemoteDataSourceRepository(dataSource: RemoteDataSource()),
        giveawaysFilterProvider: HomeGiveawayFilterProviderProtocol = HomeGiveawayFilterProvider(),
        layoutSectionProvider: HomeCollectionLayoutSectionProviderProtocol = HomeCollectionLayoutSectionProvider()
    ) {
        self.remoteDataSourceRepository = remoteDataSourceRepository
        self.giveawaysFilterProvider = giveawaysFilterProvider
        self.layoutSectionProvider = layoutSectionProvider
    }
}
