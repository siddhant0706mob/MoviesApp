//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import Network

protocol NetworkAvailabilityProvider {
    func isNetworkAvailable() -> Bool
}

class NetworkMonitor: NetworkAvailabilityProvider {
    
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private(set) var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    func isNetworkAvailable() -> Bool { isConnected }
}
