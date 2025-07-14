//
//  MovieDetailsEndpoint.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

struct MovieDetailsEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US", "page": "1"]
    
    var path: String = "/movie/"
    
    var movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
        path += "\(movieId)"
    }
}
