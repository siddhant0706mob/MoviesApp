//
//  SavedMoviesViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

protocol SavedMoviesViewModelDelegate: AnyObject {
    func reloadData()
}

protocol SavedMoviesViewModelProtocol {
    func setDelegate(_ delegate: SavedMoviesViewModelDelegate)
    func getBookMarkedMovies()
    func getNumberOfItems() -> Int
    func getTrendingMovie(at index: Int) -> MovieDetailResponse?
}

class SavedMoviesViewModel: SavedMoviesViewModelProtocol {
    
    let bookMarkService: BookmarkDataServiceProtocol
    let movieDetailsAPIService: APIServiceProtocol
    var bookMarkedMovieIds = [Int]()
    var bookMarkedMovies = [MovieDetailResponse]()
    
    weak var delegate: SavedMoviesViewModelDelegate?
    
    init(_ bookMarkService: BookmarkDataServiceProtocol = BookmarkDataService(), _ movieDetailsApiService: APIServiceProtocol = APIServiceFactory.getApiService(for: .movieDetail)) {
        self.bookMarkService = bookMarkService
        self.movieDetailsAPIService = movieDetailsApiService
        getBookMarkedMovies()
    }
    
    func setDelegate(_ delegate: any SavedMoviesViewModelDelegate) {
        self.delegate = delegate
    }
    
    private func getAllBookMarkedIds(completion: @escaping () -> Void) {
        bookMarkService.getAllBookmarkedMovies() { movies in
            self.bookMarkedMovieIds = movies
            completion()
        }
    }
    
    func getBookMarkedMovies() {
        getAllBookMarkedIds() { [weak self] in
            if self?.bookMarkedMovieIds.isEmpty == true {
                self?.bookMarkedMovies = []
                self?.delegate?.reloadData()
            }
            self?.bookMarkedMovieIds.forEach({ [weak self] bookmarkId in
                (self?.movieDetailsAPIService as? MovieDetailsServiceProtocol)?.fetchMovieDetail(with: bookmarkId, { [weak self] movie in
                    if let movie {
                        self?.bookMarkedMovies.append(movie)
                        if let bookmark = self?.bookMarkedMovies {
                            self?.bookMarkedMovies = Array(Set(bookmark))
                        }
                        self?.delegate?.reloadData()
                    }
                })
            })
        }
    }
    
    func getNumberOfItems() -> Int { bookMarkedMovies.count }
    
    func getTrendingMovie(at index: Int) -> MovieDetailResponse? {
        if index < bookMarkedMovies.count {
            return bookMarkedMovies[index]
        }
        return nil
    }
}
