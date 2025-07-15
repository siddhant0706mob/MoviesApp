//
//  HomeAPIRequest.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//
import Foundation

struct NowPlayingMoviewEndpoint: Endpoint, Codable {
    var method: HTTPMethod = .GET
    var headers: [String : String]?
    var parameters: [String : Any]? = ["language": "en-US", "page": "1"]
    var path: String = "/movie/now_playing"
    
    enum CodingKeys: String, CodingKey {
        case method
        case headers
        case parameters
        case path
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(method.rawValue, forKey: .method)
        try container.encodeIfPresent(headers, forKey: .headers)
        if let parameters = parameters as? [String: String] {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .parameters)
        }
        try container.encode(path, forKey: .path)
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
    }
}

struct PopularMovieEndpoint: Endpoint, Codable {
    var method: HTTPMethod = .GET
    var headers: [String : String]?
    var parameters: [String : Any]? = ["language": "en-US"]
    var path: String = "/trending/movie/day"
    
    enum CodingKeys: String, CodingKey {
        case method
        case headers
        case parameters
        case path
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(method.rawValue, forKey: .method)
        try container.encodeIfPresent(headers, forKey: .headers)
        if let params = parameters as? [String: String] {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            let str = String(data: data, encoding: .utf8)
            try container.encode(str, forKey: .parameters)
        }
        try container.encode(path, forKey: .path)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let methodStr = try container.decode(String.self, forKey: .method)
        method = HTTPMethod(rawValue: methodStr) ?? .GET
        headers = try container.decodeIfPresent([String: String].self, forKey: .headers)
        if let paramStr = try container.decodeIfPresent(String.self, forKey: .parameters),
           let jsonData = paramStr.data(using: .utf8),
           let dict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
            parameters = dict
        } else {
            parameters = nil
        }
        path = try container.decode(String.self, forKey: .path)
    }
}
