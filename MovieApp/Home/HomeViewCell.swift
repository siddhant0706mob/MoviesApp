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
    let movieId: Int
}

class HomeViewCell: UICollectionViewCell {
    
    var imageView = CachedImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(hex: 0x98BAE3).cgColor
        clipsToBounds = true
        backgroundColor = UIColor(hex: 0x365475)
        titleLabel.numberOfLines = 0
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(_ item: HomeViewCellModel) {
        imageView.setImage(item.image)
        titleLabel.text = item.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}

