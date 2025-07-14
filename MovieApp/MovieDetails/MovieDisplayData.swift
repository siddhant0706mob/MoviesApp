//
//  MovieDisplayData.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

struct MovieDisplayData {
    let movieTitle: String
    let tagline: String?
    let overview: String
    let releaseDate: String
    let runtime: String
    let genres: String
    let productionCompanies: String
    let budget: String
    let revenue: String
    let rating: String
    let imageURL: String?

    init(movie: MovieDetailResponse) {
        self.movieTitle = movie.title ?? ""
        self.tagline = movie.tagline
        self.overview = movie.overview ?? ""
        self.releaseDate = movie.releaseDate ?? ""
        if let runtime = movie.runtime {
            self.runtime = "\(runtime) minutes"
        } else {
            self.runtime = "N/A"
        }
        self.genres = movie.genres?.map { $0.name ?? "" }.joined(separator: ", ") ?? ""
        self.productionCompanies = movie.productionCompanies?.map { $0.name ?? "" }.joined(separator: ", ") ?? ""
        self.budget = movie.budget?.description ?? ""
        self.revenue = movie.revenue?.description ?? ""
        self.rating = movie.voteAverage?.description ?? ""
        self.imageURL = movie.posterPath
    }
}
