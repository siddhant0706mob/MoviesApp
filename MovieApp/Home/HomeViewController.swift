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
                          NowPlayingViewDataSource,
                          UITableViewDelegate,
                          UITableViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout,
                          UIScrollViewDelegate {
    private let viewModel: HomeViewModel
    private let tableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.backgroundColor = .black
        return tbl
    }()
    
    private var shouldTransform = true
    
    private let collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 120, right: 12)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        return cv
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
        setupTableView()
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
        view.addSubview(collectionView2)
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
            collectionView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView2.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 12),
            collectionView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 460),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "MovieCell2")
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(HomeViewCell.self, forCellWithReuseIdentifier: "HomeviewCell2")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell2", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        let data = viewModel.getTrendingMovie(at: indexPath.row)
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
        let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
        cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeviewCell2", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = viewModel.getTrendingMovie(at: indexPath.row)
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
        let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
        cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 160
        let cellHeight: CGFloat = 280
        return CGSize(width: cellWidth, height: cellHeight)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nowplayingHeight = nowPlayingView.frame.height + 14
        if scrollView == collectionView2,
           scrollView.contentOffset.y > 0,
           scrollView.contentOffset.y < nowplayingHeight {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.nowPlayingView.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                self.trendingLabel.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                self.flameImage.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                self.collectionView2.transform = CGAffineTransform(translationX: 0, y: 12 - scrollView.contentOffset.y)
            }
        }
    }
}
