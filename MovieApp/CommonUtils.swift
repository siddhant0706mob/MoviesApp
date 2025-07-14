//
//  CommonUtils.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

import Foundation

class CommonUtils {
    static func convertHTTPToHTTPS(urlString: String) -> String {
        guard var components = URLComponents(string: urlString) else {
            return urlString
        }
        if components.scheme == "http" {
            components.scheme = "https"
        }
        return components.url?.absoluteString ?? urlString
    }
}
