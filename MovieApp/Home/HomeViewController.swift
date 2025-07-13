//
//  ViewController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import UIKit
import Lottie

protocol HomeViewModelDelegate: AnyObject {
    func reloadTableView()
}

class HomeViewController: UIViewController,
                          HomeViewModelDelegate {
    
    private let viewModel: HomeViewModel
    
    private let tableView = UITableView()
    
//    private let collectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        cv.backgroundColor = .darkGray
//        cv.showsVerticalScrollIndicator = false
//        return cv
//    }()
    
    private let loadingView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loadingjson")
        animationView.loopMode = .loop
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleShimmer(false)
    }
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        createViews()
        self.viewModel.fetchTrendingMovies()
        self.viewModel.fetchNowPlayingMovies()
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
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "MovieCell2")
        tableView.register(NowPlayingTableViewCell.self, forCellReuseIdentifier: "nowPlayingCell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.toggleShimmer(true)
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.getNumberOfSections() }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tvSection =  HomeTableViewSection(rawValue: indexPath.section) {
            switch tvSection {
            case .nowPlaying:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as? NowPlayingTableViewCell else { return UITableViewCell() }
                let data = viewModel.getTrendingMovie(at: indexPath.row)
                let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
                let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
                let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
//                cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
                return cell
            case .trending:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell2", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
                let data = viewModel.getTrendingMovie(at: indexPath.row)
                let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
                let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
                let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
                cell.setData(HomeViewCellModel(image: imageURL, title: data.title))
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .darkGray
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        if section == 0 {
            label.text = "Trending Movies"
        } else if section == 1 {
            label.text = "Now Playing"
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    private func convertHTTPToHTTPS(urlString: String) -> String {
        guard var components = URLComponents(string: urlString) else {
            return urlString
        }
        if components.scheme == "http" {
            components.scheme = "https"
        }
        return components.url?.absoluteString ?? urlString
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int { viewModel.getNumberOfSections() }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.getNumberOfItemsInSection(section) }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        switch indexPath.section {
//        case 0, 2:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleViewCell", for: indexPath) as? HomeTitleCell else { return UICollectionViewCell() }
//            let title = viewModel.getTitleForHeader(at: indexPath.section)
//            cell.setTitle(title)
//            return cell
////        case 1:
////            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as? NowPlayingCollectionViewCell else { return UICollectionViewCell() }
////            let movies = viewModel.getNowPlayingMovies()
////            return cell
//        case 3:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
//            let data = viewModel.getTrendingMovie(at: indexPath.row)
//            let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
//            let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
//            let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
//            cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
//            return cell
//        
//        case 4:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LottieLoadingFooter", for: indexPath) as? HomeLoadingViewCell else { return UICollectionViewCell() }
//            cell.startAnimating()
//            return cell
//        default:
//            break
//        }
//        return UICollectionViewCell()
//    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row != .zero {
//            return CGSize(width: 120, height: 260)
//        }
//        if indexPath.row == 4 {
//            return CGSize(width: collectionView.bounds.width, height: 100)
//        }
//        return CGSize(width: collectionView.bounds.width, height: 40)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 8 }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
}
