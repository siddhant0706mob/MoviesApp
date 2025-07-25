import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func updateUI(with data: MovieDisplayData)
}

class MovieDetailsViewController: UIViewController, MovieDetailsViewModelDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let posterImageView = CachedImageView()
    private let bookMarkDataService: BookmarkDataServiceProtocol
    private let movieId: Int
    
    private let viewModel: MovieDetailsViewModelProtocol
    
    init(_ viewModel: MovieDetailsViewModelProtocol, movieId: Int, _ bookmarkDataService: BookmarkDataServiceProtocol = BookmarkDataService()) {
        self.viewModel = viewModel
        self.bookMarkDataService = bookmarkDataService
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
        self.viewModel.setDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBookmarkButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMovieDetails()
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.masksToBounds = true
        posterImageView.backgroundColor = .systemGray5
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.3
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        posterImageView.layer.shadowRadius = 10
        posterImageView.layer.cornerRadius = 12
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -24)
        ])
    }
    
    private func isMovieBookmarked(completion: @escaping (Bool) -> Void) {
        bookMarkDataService.isBookmarked(movieId, completion: { isBookMarked in
            completion(isBookMarked)
        })
    }

    private func updateBookMarkButton(_ isAdded: Bool) {
        let btn = navigationItem.rightBarButtonItem
        btn?.image = isAdded ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }
    
    private func setupBookmarkButton() {
        let bookmarkImage = UIImage(systemName: "bookmark")
        let bookmarkButton = UIBarButtonItem(image: bookmarkImage, style: .plain, target: self, action: #selector(bookmarkTapped))
        bookmarkButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = bookmarkButton
        isMovieBookmarked(completion: { [weak self] isBookmarked in
            self?.updateBookMarkButton(isBookmarked)
        })
    }

    @objc private func bookmarkTapped() {
        isMovieBookmarked(completion: { [weak self] isBookMarked in
            guard let self else { return }
            if isBookMarked {
                bookMarkDataService.deleteBookmark(self.movieId, completion: { [weak self] in
                    self?.updateBookMarkButton(false)
                })
            } else {
                bookMarkDataService.addBookmark(self.movieId, completion: { [weak self] in
                    self?.updateBookMarkButton(true)
                })
            }
        })
    }

    private func createLabel(_ text: String, font: UIFont, color: UIColor = .label, alignment: NSTextAlignment = .left, lines: Int = 0) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = lines
        return label
    }

    private func buildInfoStack(_ items: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        items.forEach {
            stack.addArrangedSubview(createLabel($0, font: .systemFont(ofSize: 17)))
        }
        return stack
    }
    
    func updateUI(with data: MovieDisplayData) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let posterContainer = UIView()
        posterContainer.translatesAutoresizingMaskIntoConstraints = false
        posterContainer.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(equalTo: posterContainer.centerXAnchor),
            posterImageView.topAnchor.constraint(equalTo: posterContainer.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterContainer.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        stackView.addArrangedSubview(posterContainer)
        posterContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(createLabel(data.movieTitle, font: .systemFont(ofSize: 34, weight: .bold), color: .systemIndigo, alignment: .center, lines: 2))
        
        if let tagline = data.tagline, !tagline.isEmpty {
            stackView.addArrangedSubview(createLabel(tagline, font: .systemFont(ofSize: 17, weight: .medium), color: .secondaryLabel, alignment: .center))
        }
        stackView.setCustomSpacing(24, after: stackView.arrangedSubviews.last!)
        
        stackView.addArrangedSubview(createLabel("Overview:", font: .systemFont(ofSize: 22, weight: .semibold)))
        stackView.addArrangedSubview(createLabel(data.overview, font: .systemFont(ofSize: 17)))
        stackView.setCustomSpacing(20, after: stackView.arrangedSubviews.last!)
        
        let details = [
            "Release Date: \(data.releaseDate)",
            "Runtime: \(data.runtime)",
            "Genres: \(data.genres)",
            "Production Companies: \(data.productionCompanies)"
        ]
        stackView.addArrangedSubview(buildInfoStack(details))
        stackView.setCustomSpacing(20, after: stackView.arrangedSubviews.last!)
        
        let financials = [
            "Budget: \(data.budget)",
            "Revenue: \(data.revenue)"
        ]
        stackView.addArrangedSubview(buildInfoStack(financials))
        stackView.setCustomSpacing(20, after: stackView.arrangedSubviews.last!)
        stackView.addArrangedSubview(createLabel("Rating: \(data.rating)", font: .systemFont(ofSize: 20, weight: .semibold)))
        posterImageView.setImage(CommonUtils.getImageURLFromPath(path: data.imageURL) ?? "")
    }
}
