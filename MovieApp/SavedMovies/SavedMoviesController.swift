//
//  SavedMoviesController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import UIKit

class SavedMoviesController: UIViewController,
                             UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout,
                             SavedMoviesViewModelDelegate {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let activityLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No saved movies yet"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let viewModel: SavedMoviesViewModelProtocol
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    init(_ viewModel: SavedMoviesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setDelegate(self)
        createViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityLoader.startAnimating()
        collectionView.isHidden = true
        emptyStateLabel.isHidden = true
        viewModel.getBookMarkedMovies()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SavedMoviesViewModel()
        super.init(coder: coder)
        createViews()
    }
    
    private func setupTitle() {
        navigationItem.title = "Saved Movies"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "HomeviewCell")
    }
    
    private func createViews() {
        setupTitle()
        setupCollectionView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(activityLoader)
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items  = viewModel.getNumberOfItems()
        activityLoader.stopAnimating()
        collectionView.isHidden = false
        if items == 0 {
            emptyStateLabel.isHidden = false
        } else {
            emptyStateLabel.isHidden = true
        }
        return viewModel.getNumberOfItems()
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeviewCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = viewModel.getTrendingMovie(at: indexPath.row)
        cell.setData(HomeViewCellModel(image: CommonUtils.getImageURLFromPath(path: data.posterPath) ?? "", title: data.originalTitle ?? "", movieId: data.id ?? 0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 180
        let cellHeight: CGFloat = 300
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = viewModel.getTrendingMovie(at: indexPath.row).id {
            coordinatorDelegate?.openMovieDetails(for: id)
        }
    }
}
