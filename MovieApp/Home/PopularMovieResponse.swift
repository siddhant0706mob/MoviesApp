//
//  PopularMovieResponse.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 09/07/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: MediaType
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MediaType: String, Decodable {
    case movie = "movie"
}
