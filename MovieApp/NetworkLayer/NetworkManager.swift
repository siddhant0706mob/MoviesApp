//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let interceptors: [RequestInterceptor]

    init(urlSession: URLSession = .shared, interceptors: [RequestInterceptor] = []) {
        self.urlSession = urlSession
        self.interceptors = interceptors
    }

    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let baseURL = endpoint.baseURL,
              let url = URL(string: baseURL.absoluteString + endpoint.path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: endpoint.timeout)
        request.httpMethod = endpoint.method.rawValue

        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        var interceptedRequest = request
        for interceptor in interceptors {
            interceptedRequest = interceptor.intercept(request: interceptedRequest)
        }

        return interceptedRequest
    }

    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let request = try buildRequest(from: endpoint)
            urlSession.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(.requestFailed(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 401 {
                        completion(.failure(.unauthorized))
                    } else {
                        let message = data.flatMap { String(data: $0, encoding: .utf8) }
                        completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: message)))
                    }
                    return
                }

                guard let data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }.resume()
        } catch {
            completion(.failure(error as? APIError ?? .unknown(error)))
        }
    }
}
