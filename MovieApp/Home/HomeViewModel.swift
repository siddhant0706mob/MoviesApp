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

protocol HomeViewModelProtocol {
    func fetchTrendingMovies()
    func fetchNowPlayingMovies()
    func getNumberOfItemsInSection() -> Int
    func getNowPlayingMovies() -> [Movie]
    func getTrendingMovie(at row: Int) -> Movie?
    func getMovieID(at row: Int) -> Int
    func setDelegate(_ delegate: HomeViewModelDelegate)
}

class HomeViewModel: HomeViewModelProtocol {
    private let homeAPIService: APIServiceProtocol
    
    weak var delegate: HomeViewModelDelegate?
    
    private var trendingMoives = [Movie]()
    private var nowPlayingMoview = [Movie]()
    
    init() {
        self.homeAPIService = APIServiceFactory.getApiService(for: .home)
    }
    
    func setDelegate(_ delegate: any HomeViewModelDelegate) { self.delegate = delegate }
    
    func fetchTrendingMovies() {
        (homeAPIService as? HomeAPIServiceProtocol)?.fetchTrendingMovies({ [weak self] value in
            self?.trendingMoives = value.results
            self?.delegate?.reloadCollectionView()
        })
    }
    
    func fetchNowPlayingMovies() {
        (homeAPIService as? HomeAPIServiceProtocol)?.fetchNowPlayingMovies({ [weak self] value in
            self?.trendingMoives = value.results
            self?.nowPlayingMoview = value.results
            self?.delegate?.reloadCollectionView()
        })
    }
    
    func getNumberOfItemsInSection() -> Int { trendingMoives.count }
    
    func getNowPlayingMovies() -> [Movie] { nowPlayingMoview }
    
    func getTrendingMovie(at row: Int) -> Movie? {
        if row < trendingMoives.count {
            return trendingMoives[row]
        }
        return nil
    }
    
    func getMovieID(at row: Int) -> Int {
        if row < trendingMoives.count{
            return trendingMoives[row].id
        }
        return 0
    }
}
