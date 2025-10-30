//
//  CollectionViewController.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class CollectionViewController: UIViewController {

    private let carousel = CarouselView(withFrame: .zero, andInset: 16)

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
    }

    private func setupCarousel() {
        carousel.backgroundColor = .clear

        carousel.delegate = self
        carousel.dataSource = self
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
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesMovieCell", for: indexPath) as! FavoritesMovieCell
        cell.configure()
        return cell
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
