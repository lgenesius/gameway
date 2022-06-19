//
//  RemoteDataSourceRepositoryProtocol.swift
//  Gameway
//
//  Created by Luis Genesius on 26/01/22.
//

import Foundation
import Combine

protocol RemoteDataSourceRepositoryProtocol {
    func fetchGiveaways() -> AnyPublisher<[Giveaway], Error>
    func fetchRecentGiveaways() -> AnyPublisher<[Giveaway], Error>
    func fetchFilter(params: [String: String]) -> AnyPublisher<[Giveaway], Error>
    func fetchWorth() -> AnyPublisher<Worth, Error>
}
