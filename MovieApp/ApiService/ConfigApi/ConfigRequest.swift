//
//  ConfigRequest.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

struct ConfigurationRequest: Endpoint {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]?
    
    var path: String = "/configuration"
}
