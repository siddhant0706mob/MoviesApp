//
//  HomeAPIService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 09/07/25.
//

protocol HomeAPIServiceProtocol: APIServiceProtocol {
    func fetchTrendingMovies(_ completion: @escaping (MovieResponse) -> Void)
    func fetchNowPlayingMovies(_ completion: @escaping (NowPlayingMovieResponse) -> Void)
}

class HomeAPIService: HomeAPIServiceProtocol {
    private let networkManager: NetworkServiceProtocol
    
    init() {
        networkManager = NetworkServiceFactory.getNetworkService()
    }
    
    func fetchTrendingMovies(_ completion: @escaping (MovieResponse) -> Void) {
        networkManager.request(endpoint: PopularMovieEndpoint(), responseType: MovieResponse.self, completion: { result in
            switch result {
            case .success(let value):
                completion(value)
            case .failure(_):
                break
            }
        })
    }
    
    
    func fetchNowPlayingMovies(_ completion: @escaping (NowPlayingMovieResponse) -> Void) {
        networkManager.request(endpoint: NowPlayingMoviewEndpoint(), responseType: NowPlayingMovieResponse.self, completion: { result in
            switch result {
            case .success(let value):
                completion(value)
            case .failure(_):
                break
            }
        })
    }
}
