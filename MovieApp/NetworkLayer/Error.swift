//
//  Error.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 08/07/25.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case noData
    case unauthorized
    case serverError(statusCode: Int, message: String?)
    case unknown(Error?)

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.noData, .noData): return true
        case (.unauthorized, .unauthorized): return true
        case (.requestFailed(let lErr as NSError), .requestFailed(let rErr as NSError)): return lErr.code == rErr.code && lErr.domain == rErr.domain
        case (.decodingError(let lErr as NSError), .decodingError(let rErr as NSError)): return lErr.code == rErr.code && lErr.domain == rErr.domain
        case (.serverError(let ls, let lm), .serverError(let rs, let rm)): return ls == rs && lm == rm
        case (.unknown(let lErr as NSError), .unknown(let rErr as NSError)): return lErr.code == rErr.code && lErr.domain == rErr.domain
        default: return false
        }
    }
}
