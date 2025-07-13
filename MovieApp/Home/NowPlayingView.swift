//
//  NowPlayingView.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit

protocol NowPlayingViewDataSource: AnyObject {
    func getPlayingMovies() -> [Movie]
}

class NowPlayingView: UIView,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Now Playing"
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return lbl
    }()
    
    private let imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "play.fill")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Trending & Playing"
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 12, bottom: 12, right: 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    weak var delegate: NowPlayingViewDataSource?
    
    private var dataSource = [Movie]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        backgroundColor = .black
        addSubview(titleLabel)
        addSubview(headerLabel)
        addSubview(cv)
        addSubview(imgView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .zero),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .zero),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            imgView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 14),
            imgView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 130),
            imgView.heightAnchor.constraint(equalToConstant: 24),
            imgView.widthAnchor.constraint(equalToConstant: 18),
            cv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
            cv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero),
            cv.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            cv.heightAnchor.constraint(equalToConstant: 252),
            cv.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        cv.delegate = self
        cv.dataSource = self
        cv.register(HomeViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { dataSource.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = dataSource[indexPath.row]
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? ""
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "")
        let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
        cell.setData(HomeViewCellModel(image: convertHTTPToHTTPS(urlString: imageURL), title: data.title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 144
        let cellHeight: CGFloat = 240
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    public func reloadData() {
        dataSource = delegate?.getPlayingMovies() ?? []
        cv.reloadData()
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
}
