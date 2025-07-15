//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

protocol SearchViewModelDelegate: AnyObject {
    func didFetchSearchResults(_ searchResults: [Movie])
}

protocol SearchViewModelProtocol {
    func fetchSearchResultsFor(_ query: String)
    func getResult(at index: Int) -> Movie
    func getNumberOfResults() -> Int
    func setDelegate(_ delegate: SearchViewModelDelegate)
}

class SearchViewModel: SearchViewModelProtocol {
    private let searchAPIService: APIServiceProtocol
    
    private var movies = [Movie]()
    
    weak var delegate: SearchViewModelDelegate?
    
    init(searchAPIService: APIServiceProtocol = APIServiceFactory.getApiService(for: .search)) {
        self.searchAPIService = searchAPIService
    }
    
    func setDelegate(_ delegate: any SearchViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchSearchResultsFor(_ query: String) {
        (searchAPIService as? SearchAPIServiceProtocol)?.search(query: query) { [weak self] result in
            self?.movies = result.results
            self?.delegate?.didFetchSearchResults(result.results)
        }
    }
    
    func getResult(at index: Int) -> Movie { movies[index] }
    
    func getNumberOfResults() -> Int { movies.count }
}
