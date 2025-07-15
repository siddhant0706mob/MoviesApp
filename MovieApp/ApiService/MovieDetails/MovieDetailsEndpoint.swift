//
//  MovieDetailsEndpoint.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

import Foundation
struct MovieDetailsEndpoint: Endpoint, Codable {
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]? = ["language": "en-US", "page": "1"]
    
    var path: String
    
    var movieId: Int
    
    enum CodingKeys: String, CodingKey {
        case method
        case headers
        case parameters
        case path
        case movieId
    }
    
    init(movieId: Int) {
        self.movieId = movieId
        self.path = "/movie/\(movieId)"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(method.rawValue, forKey: .method)
        try container.encodeIfPresent(headers, forKey: .headers)
        
        if let parameters = parameters as? [String: String] {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .parameters)
        } else {
            try container.encodeNil(forKey: .parameters)
        }
        
        try container.encode(path, forKey: .path)
        try container.encode(movieId, forKey: .movieId)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let methodString = try container.decode(String.self, forKey: .method)
        method = HTTPMethod(rawValue: methodString) ?? .GET
        
        headers = try container.decodeIfPresent([String: String].self, forKey: .headers)
        
        if let paramString = try container.decodeIfPresent(String.self, forKey: .parameters),
           let jsonData = paramString.data(using: .utf8),
           let dict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
            parameters = dict
        } else {
            parameters = nil
        }
        
        path = try container.decode(String.self, forKey: .path)
        movieId = try container.decode(Int.self, forKey: .movieId)
    }
}
