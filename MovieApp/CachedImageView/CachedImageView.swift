//
//  CachedImageView.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit

class CachedImageView: UIImageView {
    
    let imageCache = ImageCacheService.shared
    
    let downloadImage = ImageDownloadService.shared
    
    public func setImage(_ url: String) {
//        if let img = imageCache.getImageFromCache(url) {
//            DispatchQueue.main.async { [weak self] in
//                self?.image = img
//            }
//        }
        guard let url = URL(string: url) else { return }
        downloadImage.downloadImage(url, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        })
        
    }
}
