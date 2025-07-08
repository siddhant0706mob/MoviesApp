//
//  Untitled.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 08/07/25.
//

import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var timeout: TimeInterval { get }
}

extension Endpoint {
    var timeout: TimeInterval { TimeInterval(10) }
    
    var baseURL: URL? { URL(string: "https://api.themoviedb.org/3") }
}
