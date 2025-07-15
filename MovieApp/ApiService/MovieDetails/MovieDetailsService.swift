//
//  MovieDetailsService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

 
protocol MovieDetailsServiceProtocol: APIServiceProtocol {
    func fetchMovieDetail(with movieId: Int, _ completion: @escaping ((MovieDetailResponse?) -> Void))
}

class MovieDetailsService: MovieDetailsServiceProtocol {
    private let networkManager: DataProviderService
    
    init() {
        networkManager = DataProviderFactory.getDataProvider()
    }
    
    func fetchMovieDetail(with movieId: Int, _ completion: @escaping ((MovieDetailResponse?) -> Void)) {
        networkManager.request(endpoint: MovieDetailsEndpoint(movieId: movieId), responseType: MovieDetailResponse.self, completion: { result in
            if case let .success(response) = result {
                completion(response)
            } else if case .failure(_) = result {
                completion(nil)
            }
        })
    }
}

