//
//  ConfigAPIService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

protocol ConfigApiServiceProtocol: APIServiceProtocol {
    func fetchAndStoreConfig(_ completion: ((Result<Void, any Error>) -> Void)?)
}

struct ConfigurationStore {
    static var config: ConfigurationResponse?
}

class ConfigAPIService: ConfigApiServiceProtocol {
    private let networkManager: DataProviderService
    
    init() {
        networkManager = DataProviderFactory.getDataProvider()
    }
    
    func fetchAndStoreConfig(_ completion: ((Result<Void, any Error>) -> Void)?) {
        networkManager.request(endpoint: ConfigurationRequest(), responseType: ConfigurationResponse.self, completion: { result in
            if case let .success(config) = result {
                ConfigurationStore.config = config
                completion?(.success(()))
            } else if case let .failure(error) = result {
                completion?(.failure(error))
            }
        })
    }
}
