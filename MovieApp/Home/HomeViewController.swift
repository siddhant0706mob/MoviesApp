//
//  ViewController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import UIKit
import Lottie

protocol HomeViewModelDelegate: AnyObject {
    func reloadTableView(_ response: MovieResponse)
}

class HomeViewController: UIViewController,
                          HomeViewModelDelegate {
    
    private let viewModel: HomeViewModel
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .darkGray
        return cv
    }()
    
    private let loadingView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loadingjson")
        animationView.loopMode = .loop
        return animationView
    }()
    
    private var dataSource = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleShimmer(false)
    }
  
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        createViews()
        self.viewModel.getTrendingMovies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        view.backgroundColor = .darkGray
        createCollectionView()
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 200),
            loadingView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func createCollectionView() {
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(HomeLoadingViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LottieLoadingFooter")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func toggleShimmer(_ hide: Bool) {
        if hide {
            loadingView.stop()
            loadingView.isHidden = true
        } else {
            loadingView.play()
            loadingView.isHidden = false
        }
    }
    
    func reloadTableView(_ response: MovieResponse) {
        dataSource = response.results
        DispatchQueue.main.async { [weak self] in
            self?.toggleShimmer(true)
            self?.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
    private func convertHTTPToHTTPS(urlString: String) -> String {
        guard var components = URLComponents(string: urlString) else {
            return urlString
        }
        if components.scheme == "http" {
            components.scheme = "https"
        }
        return components.url?.absoluteString ?? urlString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { dataSource.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = dataSource[indexPath.item]
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
        let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
        cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize { CGSize(width: 120, height: 260) }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 8 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LottieLoadingFooter", for: indexPath) as? HomeLoadingViewCell else {
                return UICollectionReusableView()
            }
            footer.startAnimating()
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize { CGSize(width: collectionView.bounds.width, height: 80) }
}
