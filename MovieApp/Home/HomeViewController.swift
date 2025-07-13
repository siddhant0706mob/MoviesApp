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
        let cv  = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    private let loadingView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loadingjson")
        animationView.loopMode = .loop
        return animationView
    }()
    
    private var dataSource = [Movie]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toggleShimmer(false)
    }
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func toggleShimmer(_ hide: Bool) {
        hide ? loadingView.stop() : loadingView.play()
    }
}

extension HomeViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { dataSource.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = dataSource[indexPath.item]
        cell.setData(HomeViewCellModel(image: data.posterPath ?? "", title: data.title))
        return cell
    }

    func reloadTableView(_ response: MovieResponse) {
        dataSource = response.results
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize { CGSize(width: 180, height: 100) }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
}

