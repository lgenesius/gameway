//
//  RemoteDataSourceProtocol.swift
//  Gameway
//
//  Created by Luis Genesius on 26/01/22.
//

import Foundation
import Combine

protocol RemoteDataSourceProtocol {
    func fetchGiveaways(params: [String: String]?) -> AnyPublisher<[Giveaway], Error>
}
