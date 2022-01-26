//
//  RemoteDataSourceRepositoryProtocol.swift
//  Gameway
//
//  Created by Luis Genesius on 26/01/22.
//

import Foundation
import Combine

protocol RemoteDataSourceRepositoryProtocol {
    func fetchRecentGiveaways() -> AnyPublisher<[Giveaway], Error>
}
