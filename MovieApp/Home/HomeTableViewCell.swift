//
//  HomeTableViewCell.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func openMovieDetail(for id: Int)
}

class HomeTableViewCell: UITableViewCell {

    var id: Int?
    var imageViewCell = CachedImageView()
    let titleLabel = UILabel()
    
    weak var delegate: HomeTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .black
        titleLabel.numberOfLines = 0
        imageViewCell.contentMode = .scaleToFill
        imageViewCell.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageViewCell)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageViewCell.heightAnchor.constraint(equalToConstant: 220),
            imageViewCell.widthAnchor.constraint(equalToConstant: 132),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(greaterThanOrEqualTo: contentView.centerYAnchor)
        ])
        contentView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(didClickCell))]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ item: HomeViewCellModel) {
        imageViewCell.setImage(item.image)
        titleLabel.text = item.title
        id = item.movieId
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewCell.image = nil
        titleLabel.text = nil
    }
    
    @objc private func didClickCell() {
        delegate?.openMovieDetail(for: id ?? .zero)
    }
}
