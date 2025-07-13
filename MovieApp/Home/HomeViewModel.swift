//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 09/07/25.
//

struct PopularMovieEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US"]
    
    var path: String = "/trending/movie/day"
}

class HomeViewModel {
    private let networkManager: NetworkServiceProtocol
    
    weak var delegate: HomeViewModelDelegate?
    
    init(networkManager: NetworkServiceProtocol = NetworkServiceFactory.getNetworkService()) {
        self.networkManager = networkManager
    }

    func getTrendingMovies() {
        networkManager.request(endpoint: PopularMovieEndpoint(), responseType: MovieResponse.self, completion: { result in
            switch result {
            case .success(let value):
                self.delegate?.reloadTableView(value)
            case .failure(_):
                break
            }
        })
    }
}
