//
//  NetworkServiceFactory.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

class NetworkServiceFactory {
    static func getNetworkService() -> NetworkServiceProtocol {
        let networkManager = NetworkService(interceptors: [AuthInterceptorFactory.getAuthInterceptorForAPIToken()])
        return networkManager
    }
}
