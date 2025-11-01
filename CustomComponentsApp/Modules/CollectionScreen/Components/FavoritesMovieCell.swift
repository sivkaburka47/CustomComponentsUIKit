//
//  FavoritesMovieCell.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

class FavoritesMovieCell: CarouselCell {

    private let imageView = UIImageView()
    private var currentImageName: String?
    private var loadTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)

        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем предыдущую задачу загрузки при переиспользовании ячейки
        loadTask?.cancel()
        loadTask = nil
        currentImageName = nil
        imageView.image = nil
        imageView.backgroundColor = .systemGray5
    }

    private func setupViews() {
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5

        mainView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: mainView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }

    func configure(with show: Show) {
        // Отменяем предыдущую задачу если есть
        loadTask?.cancel()

        imageView.image = nil
        imageView.backgroundColor = .systemGray5
        currentImageName = show.imageName

        loadTask = Task { [weak self] in
            guard let self = self else { return }
            
            let image = await RemoteDataSource.shared.loadImage(imageName: show.imageName)
            
            // Проверяем что ячейка все еще показывает тот же фильм и задача не отменена
            guard !Task.isCancelled,
                  self.currentImageName == show.imageName else {
                return
            }
            
            await MainActor.run {
                // Доп проверка на случай если ячейка была переиспользована
                guard self.currentImageName == show.imageName else { return }
                
                self.imageView.image = image
                self.imageView.backgroundColor = image != nil ? .clear : .systemGray5
            }
        }
    }
}
