import UIKit

class SearchViewController: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UISearchBarDelegate,
                            SearchViewModelDelegate {
    private let viewModel: SearchViewModel
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private var movies = [Movie]()
    private var searchTimer: Timer?
    
    init(_ viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        setupUI()
        setupCollectionView()
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SearchViewModel()
        super.init(coder: coder)
    }
    
    private func configureTabBarItem() {
        tabBarItem = UITabBarItem(title: "Search your Favourite Movies",
                                  image: UIImage(systemName: "magnifyingglass"),
                                  selectedImage: UIImage(systemName: "magnifyingglass.fill"))
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Search"
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        searchBar.placeholder = "Search movies..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.performSearch(query: searchText)
        })
    }
    
    private func performSearch(query: String) {
        viewModel.fetchSearchResultsFor(query)
    }
    
    func didFetchSearchResults(_ searchResults: [Movie]) {
        movies = searchResults
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.getNumberOfResults() }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = viewModel.getResult(at: indexPath.row)
        cell.setData(HomeViewCellModel(image: CommonUtils.getImageURLFromPath(path: data.posterPath) ?? "", title: data.title, movieId: data.id))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 2
        return CGSize(width: width, height: 240)
    }
}
