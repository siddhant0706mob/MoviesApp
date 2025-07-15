//
//  SearchAPIRequest.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import Foundation

struct SearchAPIRequest: Endpoint {
    var path: String = "/search/movie"
    
    var method: HTTPMethod = .GET
    
    var headers: [String : String]?
    
    var parameters: [String : Any]?
    
    init(query: String) {
        self.parameters = ["query": query]
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case method
        case headers
        case parameters
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(method.rawValue, forKey: .method)
        try container.encodeIfPresent(headers, forKey: .headers)
        if let parameters = parameters as? [String: String] {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .parameters)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        
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
    }
}
