//
//  HomeLoadingViewCell.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit
import Lottie

class HomeLoadingViewCell: UICollectionViewCell {

    private var animationView: LottieAnimationView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimationView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimationView()
    }

    private func setupAnimationView() {
        animationView = .init(name: "Loadingjson")

        guard let animationView = animationView else { return }

        contentView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            animationView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
        ])

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
    }

    func startAnimating() {
        animationView?.play()
    }

    func stopAnimating() {
        animationView?.stop()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopAnimating()
    }
}

