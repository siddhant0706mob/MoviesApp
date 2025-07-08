//
//  SplashViewController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let colors = [UIColor.white, UIColor.black]
    
    private var counterTuple = (0,1)
    
    private let concentricRingView = ConcentricRingView()
    
    private var completeInitialAnimation = false
    
    private let playButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play")
        imageView.tintColor = .white
        return imageView
    }()
    
    public weak var delegate: SplashPresentationDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        expandRingView()
    }
    
    private func createViews() {
        view.addSubview(concentricRingView)
        view.addSubview(playButtonImage)
        concentricRingView.translatesAutoresizingMaskIntoConstraints = false
        playButtonImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            concentricRingView.topAnchor.constraint(equalTo: view.topAnchor),
            concentricRingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            concentricRingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            concentricRingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playButtonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButtonImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButtonImage.heightAnchor.constraint(equalToConstant: 70),
            playButtonImage.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func updateColors() {
        self.playButtonImage.tintColor = colors[counterTuple.0]
        self.concentricRingView.setRingColor(colors[counterTuple.1])
        counterTuple.0 = (counterTuple.0 + 1) % colors.count
        counterTuple.1 = (counterTuple.1 + 1) % colors.count
    }
    
    private func expandRingView() {
        guard !completeInitialAnimation else { return }
        UIView.animate(withDuration: 1.5, delay: .zero, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.4, animations: { [weak self] in
            guard let self else { return }
            self.concentricRingView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.playButtonImage.transform = CGAffineTransform.identity
            self.updateColors()
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.contractRingView()
        })
    }
    
    private func contractRingView() {
        guard !completeInitialAnimation else { return }
        UIView.animate(withDuration: 1.5, delay: .zero, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.4, animations: { [weak self] in
            guard let self else { return }
            self.concentricRingView.transform = CGAffineTransform.identity
            self.playButtonImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.updateColors()
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.expandRingView()
        })
    }
    
    public func dismissSplash() {
        completeInitialAnimation = true
        playButtonImage.image = UIImage(systemName: "play.fill")
        playButtonImage.tintColor = .blue
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self else { return }
            self.concentricRingView.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
            self.playButtonImage.transform = CGAffineTransform(scaleX: .zero, y: .zero)
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.delegate?.splashDidFinishLaunching()
        })
    }
}
