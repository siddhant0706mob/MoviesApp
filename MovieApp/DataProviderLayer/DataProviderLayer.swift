//
//  DataProviderLayer.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import Foundation

protocol DataProviderService {
    func request<T: Codable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

class DataProviderLayer: DataProviderService {
    
    private let networkLayer: NetworkServiceProtocol
    private let localDataLayer: LocalDataProviderProtocol
    private let networkMonitor: NetworkAvailabilityProvider
    
    init(networkLayer: NetworkServiceProtocol = NetworkServiceFactory.getNetworkService(), localDataLayer: LocalDataProviderProtocol = CachingService.shared, networkMonitor: NetworkAvailabilityProvider = NetworkMonitor.shared) {
        self.networkLayer = networkLayer
        self.localDataLayer = localDataLayer
        self.networkMonitor = networkMonitor
    }
    
    func request<T: Codable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        let serializedEndpointKey = try? String(data: JSONEncoder().encode(endpoint), encoding: .utf8)
        if networkMonitor.isNetworkAvailable() {
            networkLayer.request(endpoint: endpoint, responseType: T.self, completion: {
                [weak self] result in
                if case let .success(data) = result {
                    if let serializedEndpointKey {
                        let encoder = JSONEncoder()
                        if let data = try? encoder.encode(data),
                           let jsonString = String(data: data, encoding: .utf8) {
                            self?.localDataLayer.saveResponse(for: serializedEndpointKey, data: jsonString)
                        }
                    }
                }
                completion(result)
            })
        } else {
            if let serializedEndpointKey = serializedEndpointKey {
                localDataLayer.getResponse(for: serializedEndpointKey , completion: { result in
                    if let data = result?.data(using: .utf8) {
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(decodedObject))
                        } catch {
                            completion(.failure(.noInternetConnection))
                        }
                    }
                    completion(.failure(.noData))
                })
            }
        }
    }
}
