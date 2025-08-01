//
//  APIServiceFactory.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

enum APIServiceType {
    case configuration
    case home
    case movieDetail
    case search
}

protocol APIServiceProtocol: AnyObject {
}

class APIServiceFactory {
    
    static func getApiService(for type: APIServiceType) -> APIServiceProtocol {
        switch type {
        case .configuration:
            return ConfigAPIService()
        case .home:
            return HomeAPIService()
        case .movieDetail:
            return MovieDetailsService()
        case .search:
            return SearchAPIService()
        }
    }
    
}
