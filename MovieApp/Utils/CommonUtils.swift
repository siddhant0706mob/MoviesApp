//
//  CommonUtils.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

import Foundation

class CommonUtils {
    
    static func getImageURLFromPath(path: String?) -> String? {
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
        let imageURL = baseImagePath + imageSize + (path ?? "")
        return convertHTTPToHTTPS(urlString: imageURL)
    }
    
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
