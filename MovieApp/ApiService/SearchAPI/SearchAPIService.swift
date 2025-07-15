//
//  SearchAPIService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

protocol SearchAPIServiceProtocol: APIServiceProtocol {
    func search(query: String, _ completion: @escaping((MovieResponse) -> Void))
}

class SearchAPIService: SearchAPIServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkServiceFactory.getNetworkService()) {
        self.networkService = networkService
    }
    
    func search(query: String, _ completion: @escaping(MovieResponse) -> Void) {
        networkService.request(endpoint: SearchAPIRequest(query: query), responseType: MovieResponse.self, completion: { (result) in
            if case let .success(response) = result {
                completion(response)
            } else {
                
            }
        })
    }
}
