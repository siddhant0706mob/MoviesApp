//
//  ImageCacheService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit

class ImageCacheService {
    
    private init() {}
    
    static let shared = ImageCacheService()
    
    let cache = NSCache<NSString, UIImage>()
    
    func setCache(_ urlString: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: urlString))
    }
    
    func getImageFromCache(_ urlString: String) -> UIImage? {
        return cache.object(forKey: NSString(string: urlString))
    }
}
