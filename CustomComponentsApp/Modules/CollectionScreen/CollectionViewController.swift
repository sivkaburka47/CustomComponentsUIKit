//
//  CollectionViewController.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class CollectionViewController: UIViewController {

    private let carousel = CarouselView(withFrame: .zero, andInset: 16)
    private var shows: [Show] = []

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection View"
        view.backgroundColor = .systemBackground
        setupCarousel()
        loadShows()
    }
    
    private func loadShows() {
        Task {
            do {
                shows = try await RemoteDataSource.shared.fetchShows()
                await MainActor.run {
                    carousel.reloadData()
                }
            } catch {
                print("Ошибка загрузки данных: \(error)")
            }
        }
    }

    private func setupCarousel() {
        carousel.backgroundColor = .clear

        carousel.delegate = self
        carousel.dataSource = self
        carousel.prefetchDataSource = self
        carousel.register(FavoritesMovieCell.self, forCellWithReuseIdentifier: "FavoritesMovieCell")
        carousel.showsHorizontalScrollIndicator = false
        carousel.itemSpacing = 12

        view.addSubview(carousel)

        carousel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.heightAnchor.constraint(equalToConstant: 252)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesMovieCell", for: indexPath) as! FavoritesMovieCell
        cell.configure(with: shows[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.item < shows.count else { continue }
            let show = shows[indexPath.item]
            RemoteDataSource.shared.prefetchImage(imageName: show.imageName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.item < shows.count else { continue }
            let show = shows[indexPath.item]
            RemoteDataSource.shared.cancelPrefetch(imageName: show.imageName)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.35, height: collectionView.frame.height / 1.1)
    }

    // Для плавного скролла
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        carousel.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
