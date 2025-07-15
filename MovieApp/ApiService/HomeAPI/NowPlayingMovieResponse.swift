//
//  NowPlayingMovieResponse.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//
struct NowPlayingMovieResponse: Codable {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dates = try container.decode(Dates.self, forKey: .dates)
        page = try container.decode(Int.self, forKey: .page)
        results = try container.decode([Movie].self, forKey: .results)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dates, forKey: .dates)
        try container.encode(page, forKey: .page)
        try container.encode(results, forKey: .results)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(totalResults, forKey: .totalResults)
    }
    
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
    
    enum CodingKeys: String, CodingKey {
        case maximum, minimum
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        maximum = try container.decode(String.self, forKey: .maximum)
        minimum = try container.decode(String.self, forKey: .minimum)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(maximum, forKey: .maximum)
        try container.encode(minimum, forKey: .minimum)
    }
}
