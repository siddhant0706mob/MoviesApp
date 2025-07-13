//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 09/07/25.
//

struct NowPlayingMoviewEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US", "page": "1"]
    
    var path: String = "/movie/now_playing"
}

struct PopularMovieEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US"]
    
    var path: String = "/trending/movie/day"
}

enum HomeTableViewSection: Int, CaseIterable {
    case nowPlaying
    case trending
}

class HomeViewModel {
    private let networkManager: NetworkServiceProtocol
    
    weak var delegate: HomeViewModelDelegate?
    
    private var trendingMoives = [Movie]()
    private var nowPlayingMoview = [Movie]()
    
    init(networkManager: NetworkServiceProtocol = NetworkServiceFactory.getNetworkService()) {
        self.networkManager = networkManager
    }
    
    func fetchTrendingMovies() {
        networkManager.request(endpoint: PopularMovieEndpoint(), responseType: MovieResponse.self, completion: { [weak self] result in
            switch result {
            case .success(let value):
                self?.trendingMoives = value.results
                self?.delegate?.reloadTableView()
            case .failure(_):
                break
            }
        })
    }
    
    func fetchNowPlayingMovies() {
        networkManager.request(endpoint: NowPlayingMoviewEndpoint(), responseType: NowPlayingMovieResponse.self, completion: { [weak self] result in
            switch result {
            case .success(let value):
                self?.nowPlayingMoview = value.results
                self?.delegate?.reloadTableView()
            case .failure(_):
                break
            }
        })
    }
    
    func getNumberOfSections() -> Int { 2 }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
        trendingMoives.count

//        if let tvSection =  HomeTableViewSection(rawValue: section) {
//            switch tvSection {
//                case .nowPlaying:
//                return 1
//            case .trending:
//                return trendingMoives.count
//            }
//        }
//        return .zero
    }
    
    func getTitleForHeader(at section: Int) -> String {
        switch section {
        case 0:
            return "Now Playing"
        case 2:
            return "Trending"
        default:
            break
        }
        return ""
    }
    
    func getNowPlayingMovies() -> [Movie] { nowPlayingMoview }
    
    func getTrendingMovie(at row: Int) -> Movie { trendingMoives[row] }
}
