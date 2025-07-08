//
//  SplashView.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//
import UIKit

class ConcentricRingView: UIView {

    private let outerCircleView = UIView()
    private let innerCircleView = UIView()
    private var outerRingColor = UIColor.white
    private var innerHoleColor = UIColor.gray
    private var outerDiameter: CGFloat = 220
    private var innerDiameter: CGFloat = 180

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(outerCircleView)
        addSubview(innerCircleView)
        
        backgroundColor = .gray
        outerCircleView.backgroundColor = outerRingColor
        innerCircleView.backgroundColor = innerHoleColor

        outerCircleView.translatesAutoresizingMaskIntoConstraints = false
        innerCircleView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            outerCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircleView.widthAnchor.constraint(equalToConstant: outerDiameter),
            outerCircleView.heightAnchor.constraint(equalToConstant: outerDiameter),

            innerCircleView.centerXAnchor.constraint(equalTo: outerCircleView.centerXAnchor),
            innerCircleView.centerYAnchor.constraint(equalTo: outerCircleView.centerYAnchor),
            innerCircleView.widthAnchor.constraint(equalToConstant: innerDiameter),
            innerCircleView.heightAnchor.constraint(equalToConstant: innerDiameter)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        outerCircleView.layer.cornerRadius = outerCircleView.bounds.width / 2
        innerCircleView.layer.cornerRadius = innerCircleView.bounds.width / 2
    }
    
    public func setRingColor(_ color: UIColor) {
        outerCircleView.backgroundColor = color
    }
}
