//
//  NowPlayingView.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 13/07/25.
//

import UIKit

protocol NowPlayingViewDelegate: AnyObject {
    func didSelectMovie(_ id: Int)
}

protocol NowPlayingViewDataSource: AnyObject {
    func getPlayingMovies() -> [Movie]
}

class NowPlayingView: UIView,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "Now Playing"
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return lbl
    }()
    
    private let imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "play.fill")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
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
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    weak var dataSource: NowPlayingViewDataSource?
    weak var delegate: NowPlayingViewDelegate?
    
    private var data = [Movie]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        backgroundColor = .white
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { data.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? HomeViewCell else { return UICollectionViewCell() }
        let data = data[indexPath.row]
        cell.setData(HomeViewCellModel(image: CommonUtils.getImageURLFromPath(path: data.posterPath) ?? "", title: data.title, movieId: data.id))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 144
        let cellHeight: CGFloat = 240
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = data[indexPath.row].id
        delegate?.didSelectMovie(id)
    }
    
    public func reloadData() {
        data = dataSource?.getPlayingMovies() ?? []
        cv.reloadData()
    }
}
