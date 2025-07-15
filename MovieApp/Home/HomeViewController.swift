//
//  ViewController.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import UIKit
import Lottie

protocol HomeViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

class HomeViewController: UIViewController,
                          HomeViewModelDelegate,
                          NowPlayingViewDataSource,
                          NowPlayingViewDelegate,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout,
                          UIScrollViewDelegate {
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    private let viewModel: HomeViewModelProtocol
    
    private var shouldTransform = true
    
    private let collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 120, right: 12)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
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
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trendingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "Trending"
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let flameImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "flame"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleShimmer(false)
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
    }
    
    init(_ viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setDelegate(self)
        createViews()
        setupCollectionView()
        viewModel.fetchTrendingMovies()
        viewModel.fetchNowPlayingMovies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        nowPlayingView.dataSource = self
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
            collectionView2.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: .zero),
            collectionView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 460),
        ])
    }
    
    private func setupCollectionView() {
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
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.toggleShimmer(true)
            self?.nowPlayingView.reloadData()
        }
    }
    
    func getPlayingMovies() -> [Movie] {
        viewModel.getNowPlayingMovies()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeviewCell2", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        if let data = viewModel.getTrendingMovie(at: indexPath.row) {
            cell.setData(HomeViewCellModel(image: CommonUtils.getImageURLFromPath(path: data.posterPath) ?? "", title: data.title, movieId: data.id))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 160
        let cellHeight: CGFloat = 280
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView2,
           scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.nowPlayingView.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.lineView.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.trendingLabel.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.flameImage.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.collectionView2.transform = CGAffineTransform(translationX: 0, y: 12 - min(scrollView.contentOffset.y, 370))
            }
        } else if scrollView == collectionView2 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.nowPlayingView.transform = .identity
                self.lineView.transform = .identity
                self.trendingLabel.transform = .identity
                self.flameImage.transform = .identity
                self.collectionView2.transform = .identity
            }
        }
        
        if scrollView.contentOffset.y >= 370 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.nowPlayingView.alpha = .zero
                self?.flameImage.alpha = .zero
                self?.lineView.alpha = .zero
                self?.trendingLabel.textAlignment = .center
            }
        } else {
            self.nowPlayingView.alpha = 1
            self.lineView.alpha = 1
            self.flameImage.alpha = 1
            self.trendingLabel.textAlignment = .left
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView2,
           scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.nowPlayingView.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.lineView.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.trendingLabel.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.flameImage.transform = CGAffineTransform(translationX: 0, y: -min(scrollView.contentOffset.y, 370))
                self.collectionView2.transform = CGAffineTransform(translationX: 0, y: 12 - min(scrollView.contentOffset.y, 370))
            }
        }  else if scrollView == collectionView2 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.nowPlayingView.transform = .identity
                self.lineView.transform = .identity
                self.trendingLabel.transform = .identity
                self.flameImage.transform = .identity
                self.collectionView2.transform = .identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.getMovieID(at: indexPath.row)
        openMovieDetail(for: id)
    }
    
    func didSelectMovie(_ id: Int) {
        openMovieDetail(for: id)
    }
    
    func openMovieDetail(for id: Int) {
        coordinatorDelegate?.openMovieDetails(for: id)
    }
}
