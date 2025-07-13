//
//  ConfigResponse.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//
struct ConfigurationResponse: Decodable {
    let changeKeys: [String]
    let images: Images
    
    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }
}

struct Images: Decodable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}
