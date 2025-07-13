//
//  APIServiceFactory.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

enum APIServiceType {
    case configuration
//    case trendingMovies
//    case nowPlayingMovies
}

protocol APIServiceProtocol: AnyObject {
}

class APIServiceFactory {
    
    static func getApiService(for type: APIServiceType) -> APIServiceProtocol {
        switch type {
        case .configuration:
            return ConfigAPIService()
        }
    }
    
}
