//
//  Home.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

import UIKit

struct HomeViewCellModel {
    let image: String
    let title: String
}

class HomeViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(_ item: HomeViewCellModel) {
        if let url = URL(string: item.image) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil,
                      let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume()
        }
        titleLabel.text = item.title
    }
}

