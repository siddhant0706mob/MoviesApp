//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 09/07/25.
//

enum HomeTableViewSection: Int, CaseIterable {
    case nowPlaying
    case trending
}

class HomeViewModel {
    private let homeAPIService: APIServiceProtocol
    
    weak var delegate: HomeViewModelDelegate?
    
    private var trendingMoives = [Movie]()
    private var nowPlayingMoview = [Movie]()
    
    init() {
        self.homeAPIService = APIServiceFactory.getApiService(for: .home)
    }
    
    func fetchTrendingMovies() {
        (homeAPIService as? HomeAPIServiceProtocol)?.fetchTrendingMovies({ [weak self] value in
            self?.trendingMoives = value.results
            self?.delegate?.reloadTableView()
        })
    }
    
    func fetchNowPlayingMovies() {
        (homeAPIService as? HomeAPIServiceProtocol)?.fetchNowPlayingMovies({ [weak self] value in
            self?.trendingMoives = value.results
            self?.nowPlayingMoview = value.results
            self?.delegate?.reloadTableView()
        })
    }
    
    func getNumberOfItemsInSection() -> Int { trendingMoives.count }
    
    func getNowPlayingMovies() -> [Movie] { nowPlayingMoview }
    
    func getTrendingMovie(at row: Int) -> Movie { trendingMoives[row] }
    
    func getMovieID(at row: Int) -> Int { trendingMoives[row].id }
}
