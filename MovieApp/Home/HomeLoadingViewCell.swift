//
//  HomeLoadingViewCell.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit
import Lottie

class HomeLoadingViewCell: UITableViewCell {

    private var animationView: LottieAnimationView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            animationView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            animationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 100),
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

