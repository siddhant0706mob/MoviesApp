////
////  ViewController.swift
////  MovieApp
////
////  Created by Siddhant Ranjan on 07/07/25.
////
//
import UIKit
import Lottie

protocol HomeViewModelDelegate: AnyObject {
    func reloadTableView()
}

class HomeViewController: UIViewController,
                          HomeViewModelDelegate,
                          NowPlayingViewDataSource {
    private let viewModel: HomeViewModel
    private let tableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.backgroundColor = .black
        return tbl
    }()
    
    private let nowPlayingView = NowPlayingView()
    
    private let loadingView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loadingjson")
        animationView.loopMode = .loop
        return animationView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trendingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Trending"
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let flameImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "flame"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleShimmer(false)
        navigationItem.hidesBackButton = true
        view.backgroundColor = .black
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
        nowPlayingView.delegate = self
        view.addSubview(nowPlayingView)
        view.addSubview(lineView)
        view.addSubview(trendingLabel)
        view.addSubview(flameImage)
        view.addSubview(tableView)
        nowPlayingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowPlayingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nowPlayingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nowPlayingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: nowPlayingView.bottomAnchor, constant: 6),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.bottomAnchor.constraint(equalTo: nowPlayingView.bottomAnchor, constant: 8),
            trendingLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 6),
            trendingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            trendingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            trendingLabel.heightAnchor.constraint(equalToConstant: 36),
            flameImage.centerYAnchor.constraint(equalTo: trendingLabel.centerYAnchor, constant: 2),
            flameImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 106),
            flameImage.widthAnchor.constraint(equalToConstant: 24),
            flameImage.heightAnchor.constraint(equalToConstant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            self?.nowPlayingView.reloadData()
        }
    }
    
    func getPlayingMovies() -> [Movie] {
        viewModel.getNowPlayingMovies()
    }
}

//
//class HomeViewController: UIViewController,
//                          HomeViewModelDelegate {
//
//    private let viewModel: HomeViewModel
//    private let tableView = UITableView()
//
//    private let nowPlayingView = UIView()
//
//    private let loadingView: LottieAnimationView = {
//        let animationView = LottieAnimationView(name: "Loadingjson")
//        animationView.loopMode = .loop
//        return animationView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        toggleShimmer(false)
//    }
//
//    init(_ viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//        viewModel.delegate = self
//        createViews()
//        self.viewModel.fetchTrendingMovies()
//        self.viewModel.fetchNowPlayingMovies()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func createViews() {
//        view.backgroundColor = .darkGray
//        createCollectionView()
//        view.addSubview(loadingView)
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            loadingView.widthAnchor.constraint(equalToConstant: 200),
//            loadingView.heightAnchor.constraint(equalToConstant: 200),
//        ])
//    }
//
//    private func createCollectionView() {
//        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "MovieCell2")
//        tableView.register(NowPlayingTableViewCell.self, forCellReuseIdentifier: "nowPlayingCell")
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
//        ])
//    }
//
//    private func toggleShimmer(_ hide: Bool) {
//        if hide {
//            loadingView.stop()
//            loadingView.isHidden = true
//        } else {
//            loadingView.play()
//            loadingView.isHidden = false
//        }
//    }
//
//    func reloadTableView() {
//        DispatchQueue.main.async { [weak self] in
//            self?.toggleShimmer(true)
//            self?.tableView.reloadData()
//        }
//    }
//}
//
//extension HomeViewController: UITableViewDelegate,
//                              UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.getNumberOfSections() }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        if let tvSection =  HomeTableViewSection(rawValue: indexPath.section) {
////            switch indexPath.section {
//////            case .nowPlaying:
////                guard let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as? NowPlayingTableViewCell else { return UITableViewCell() }
////                let data = viewModel.getTrendingMovie(at: indexPath.row)
////                let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
////                let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
////                let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
//////                cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
////                return cell
////            case 0:
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell2", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
//                let data = viewModel.getTrendingMovie(at: indexPath.row)
//                let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
//                let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
//                let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
//                cell.setData(HomeViewCellModel(image: imageURL, title: data.title))
//                return cell
////            default:
////                break
////            }
////        }
////        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .darkGray
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        headerView.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//
//        if section == 0 {
//            label.text = "Trending Movies"
//        } else if section == 1 {
//            label.text = "Now Playing"
//        }
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//
//    private func convertHTTPToHTTPS(urlString: String) -> String {
//        guard var components = URLComponents(string: urlString) else {
//            return urlString
//        }
//        if components.scheme == "http" {
//            components.scheme = "https"
//        }
//        return components.url?.absoluteString ?? urlString
//    }
//}
