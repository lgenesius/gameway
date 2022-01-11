//
//  NetworkManager.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation
import Combine

enum APIError: Error, CustomNSError {
    case apiError
    case invalidURL
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch data: API Error."
        case .invalidURL:
            return "Failed to fetch data: Invalid URL."
        case .invalidResponse:
            return "Failed to fetch data: Invalid Response."
        case .noData:
            return "Failed to fetch data: No Data."
        case .serializationError:
            return "Failed to fetch data: Serialization Error."
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseAPIURL = "https://www.gamerpower.com/api"
    private let urlSession = URLSession.shared
    
    private var anyCancelable = Set<AnyCancellable>()
    
    func fetchGiveaways(params: [String: String]? = nil) -> AnyPublisher<[Giveaway], Error> {
        return Future<[Giveaway], Error> { [weak self] promise in
            guard let self = self else { return }
            
            guard let url = URL(string: self.baseAPIURL + "/giveaways") else {
                promise(.failure(APIError.invalidURL))
                return
            }
            
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                promise(.failure(APIError.invalidURL))
                return
            }
            
            var queryItems: [URLQueryItem]?
            if let params = params {
                queryItems?.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) } )
            }
            
            urlComponents.queryItems = queryItems
            
            guard let finalURL = urlComponents.url else {
                promise(.failure(APIError.invalidURL))
                return
            }
            
            self.urlSession.dataTaskPublisher(for: finalURL)
                .retry(1)
                .mapError { $0 }
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [Giveaway].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { giveaways in
                    promise(.success(giveaways))
                }
                .store(in: &self.anyCancelable)
        }
        .eraseToAnyPublisher()
    }
}
