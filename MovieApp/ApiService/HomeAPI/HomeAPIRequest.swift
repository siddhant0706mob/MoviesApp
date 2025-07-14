//
//  HomeAPIRequest.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//
struct NowPlayingMoviewEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US", "page": "1"]
    
    var path: String = "/movie/now_playing"
}

struct PopularMovieEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US"]
    
    var path: String = "/trending/movie/day"
}
