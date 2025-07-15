//
//  SearchAPIRequest.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

struct SearchAPIRequest: Endpoint {
    var path: String = "/search/movie"
    
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]?
    
    init(query: String) {
        self.parameters = ["query": query]
    }
}
