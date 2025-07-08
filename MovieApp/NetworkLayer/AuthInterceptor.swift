//
//  AuthInterceptor.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 08/07/25.
//

import Foundation

protocol RequestInterceptor {
    func intercept(request: URLRequest) -> URLRequest
}

class AuthInterceptor: RequestInterceptor {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func intercept(request: URLRequest) -> URLRequest {
        var mutableRequest = request
        mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
}
