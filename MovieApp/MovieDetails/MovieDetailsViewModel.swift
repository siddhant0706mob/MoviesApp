//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

import UIKit

protocol MovieDetailsViewModelProtocol {
    func setDelegate(_ delegate: MovieDetailsViewModelDelegate?)
    func fetchMovieDetails()
}

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    private let movieDetailService: APIServiceProtocol
 
    weak var delegate: MovieDetailsViewModelDelegate?
    
    private let movieId: Int
    
    init (movieId: Int) {
        self.movieId = movieId
        self.movieDetailService = APIServiceFactory.getApiService(for: .movieDetail)
    }
    
    func fetchMovieDetails() {
        (movieDetailService as? MovieDetailsServiceProtocol)?.fetchMovieDetail(with: movieId, { [weak self] movie in
            if let movie {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.updateUI(with: MovieDisplayData(movie: movie))
                }
            }
        })
    }
    func setDelegate(_ delegate: (any MovieDetailsViewModelDelegate)?) {
        self.delegate = delegate
    }
}
