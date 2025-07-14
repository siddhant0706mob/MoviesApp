//
//  MovieDetailsController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 14/07/25.
//

import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func updateUI(with data: MovieDisplayData)
}

class MovieDetailsViewController: UIViewController, MovieDetailsViewModelDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let posterImageView = CachedImageView()
    
    let viewModel: MovieDetailsViewModel
    
    init(movieId: Int) {
        self.viewModel = MovieDetailsViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMovieDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .systemGray5
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func createLabel(text: String, font: UIFont, textColor: UIColor = .label, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        return label
    }
    
    func updateUI(with data: MovieDisplayData) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let posterContainer = UIView()
        posterContainer.translatesAutoresizingMaskIntoConstraints = false
        posterContainer.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(equalTo: posterContainer.centerXAnchor),
            posterImageView.topAnchor.constraint(equalTo: posterContainer.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterContainer.bottomAnchor)
        ])
        stackView.addArrangedSubview(posterContainer)
        posterContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        stackView.addArrangedSubview(createLabel(text: data.movieTitle, font: .preferredFont(forTextStyle: .largeTitle), textColor: .label, numberOfLines: 2, textAlignment: .center))
        if let tagline = data.tagline, !tagline.isEmpty {
            stackView.addArrangedSubview(createLabel(text: tagline, font: .preferredFont(forTextStyle: .headline), textColor: .secondaryLabel, textAlignment: .center))
        }
        
        stackView.setCustomSpacing(24, after: stackView.arrangedSubviews.last!)
        stackView.addArrangedSubview(createLabel(text: "Overview:", font: .preferredFont(forTextStyle: .title2), textAlignment: .left))
        stackView.addArrangedSubview(createLabel(text: data.overview, font: .preferredFont(forTextStyle: .body), textAlignment: .left))
        stackView.setCustomSpacing(20, after: stackView.arrangedSubviews.last!)

        let detailsStack = UIStackView()
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        detailsStack.alignment = .leading
        detailsStack.isLayoutMarginsRelativeArrangement = true
        detailsStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        detailsStack.addArrangedSubview(createLabel(text: "Release Date: \(data.releaseDate)", font: .preferredFont(forTextStyle: .body)))
        detailsStack.addArrangedSubview(createLabel(text: "Runtime: \(data.runtime)", font: .preferredFont(forTextStyle: .body)))
        detailsStack.addArrangedSubview(createLabel(text: "Genres: \(data.genres)", font: .preferredFont(forTextStyle: .body)))
        detailsStack.addArrangedSubview(createLabel(text: "Production Companies: \(data.productionCompanies)", font: .preferredFont(forTextStyle: .body)))
        
        stackView.addArrangedSubview(detailsStack)
        stackView.setCustomSpacing(20, after: detailsStack)

        let financialsStack = UIStackView()
        financialsStack.axis = .vertical
        financialsStack.spacing = 8
        financialsStack.alignment = .leading
        financialsStack.isLayoutMarginsRelativeArrangement = true
        financialsStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        financialsStack.addArrangedSubview(createLabel(text: "Budget: \(data.budget)", font: .preferredFont(forTextStyle: .body)))
        financialsStack.addArrangedSubview(createLabel(text: "Revenue: \(data.revenue)", font: .preferredFont(forTextStyle: .body)))
        
        stackView.addArrangedSubview(financialsStack)
        stackView.setCustomSpacing(20, after: financialsStack)
        stackView.addArrangedSubview(createLabel(text: "Rating: \(data.rating)", font: .preferredFont(forTextStyle: .title3), textAlignment: .left))
        posterImageView.setImage(CommonUtils.convertHTTPToHTTPS(urlString: data.imageURL ?? ""))
    }
}

//
//class MovieDetailsViewController: UIViewController,
//                                  MovieDetailsViewModelDelegate {
//    
//    private let scrollView = UIScrollView()
//    private let stackView = UIStackView()
//    
//    let viewModel: MovieDetailsViewModel
//    
//    init(movieId: Int) {
//        self.viewModel = MovieDetailsViewModel(movieId: movieId)
//        super.init(nibName: nil, bundle: nil)
//        viewModel.delegate = self
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.fetchMovieDetails()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        
//        view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        
//        scrollView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.alignment = .leading
//        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//        ])
//    }
//    
//    private func createLabel(text: String, font: UIFont, textColor: UIColor = .label, numberOfLines: Int = 0) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.font = font
//        label.textColor = textColor
//        label.numberOfLines = numberOfLines
//        return label
//    }
//    
//    func updateUI(with data: MovieDisplayData) {
//        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        stackView.addArrangedSubview(createLabel(text: data.movieTitle, font: .preferredFont(forTextStyle: .largeTitle), numberOfLines: 2))
//        
//        if let tagline = data.tagline, !tagline.isEmpty {
//            stackView.addArrangedSubview(createLabel(text: tagline, font: .preferredFont(forTextStyle: .headline), textColor: .secondaryLabel))
//        }
//        
//        stackView.addArrangedSubview(createLabel(text: "Overview:", font: .preferredFont(forTextStyle: .title2)))
//        stackView.addArrangedSubview(createLabel(text: data.overview, font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Release Date: \(data.releaseDate)", font: .preferredFont(forTextStyle: .body)))
//        stackView.addArrangedSubview(createLabel(text: "Runtime: \(data.runtime)", font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Genres:", font: .preferredFont(forTextStyle: .body)))
//        stackView.addArrangedSubview(createLabel(text: data.genres, font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Production Companies:", font: .preferredFont(forTextStyle: .body)))
//        stackView.addArrangedSubview(createLabel(text: data.productionCompanies, font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Budget: \(data.budget)", font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Revenue: \(data.revenue)", font: .preferredFont(forTextStyle: .body)))
//        
//        stackView.addArrangedSubview(createLabel(text: "Rating: \(data.rating)", font: .preferredFont(forTextStyle: .body)))
//    }
//}
