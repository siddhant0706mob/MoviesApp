//
//  ImageDownloadService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import Foundation
import UIKit

class ImageDownloadService {
    
    let cacheService = ImageCacheService.shared
    
    static let shared = ImageDownloadService()
    
    private init() {
        
    }
    
    func downloadImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data {
                if let image = UIImage(data: data) {
                    self?.cacheService.setCache(url.absoluteString, image: image)
                    completion(image)
                } else {
                    
                }
            }
        }.resume()
    }
}
