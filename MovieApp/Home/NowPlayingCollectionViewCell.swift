import UIKit

class NowPlayingTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    private var horizontalCollectionView: UICollectionView!

    private var movies: [Movie] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray // Set content view background to match your table view
        selectionStyle = .none // Typically, you don't want selection on a cell that contains a collection view
        setupHorizontalCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHorizontalCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12) // Add horizontal padding here

        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        horizontalCollectionView.backgroundColor = .clear // Important: Set to clear to see table view background
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "MovieCell") // Register HomeViewCell for the inner collection view

        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with movies: [Movie]) {
        self.movies = movies
        horizontalCollectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource for horizontalCollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? HomeViewCell else {
            return UICollectionViewCell()
        }
        let data = movies[indexPath.item]
        let baseImagePath = ConfigurationStore.config?.images.baseURL ?? "https://image.tmdb.org/t/p/"
        let imageSize = (ConfigurationStore.config?.images.posterSizes.first ?? "w500")
        let imageURL = baseImagePath + imageSize + (data.posterPath ?? "")
        cell.setData(HomeViewCellModel(image: CommonUtils.convertHTTPToHTTPS(urlString: imageURL), title: data.title, movieId: data.id))
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout for horizontalCollectionView

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 260) // Size for horizontal movie cells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8 // Spacing between items in the horizontal collection view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8 // Spacing between items in the horizontal collection view
    }
}
