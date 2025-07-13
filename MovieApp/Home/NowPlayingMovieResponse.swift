//
//  NowPlayingMovieResponse.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

struct NowPlayingMovieResponse: Decodable {
    let dates: Dates
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Decodable {
    let maximum: String
    let minimum: String
}
