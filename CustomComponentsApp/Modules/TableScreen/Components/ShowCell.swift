//
//  ShowCell.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 01.11.2025.
//

import UIKit

final class ShowCell: UITableViewCell {

    // MARK: - UI Elements

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingContainer = UIView()
    private let ratingLabel = UILabel()
    private let textStack = UIStackView()
    private let mainContainer = UIView()
    
    // MARK: - Properties
    
    private var currentImageName: String?
    private var loadTask: Task<Void, Never>?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
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
        posterImageView.image = nil
        posterImageView.backgroundColor = .systemGray5
    }

    // MARK: - Configuration

    func configure(with show: Show) {
        titleLabel.text = show.title
        infoLabel.text = "\(show.year) • \(show.country)"
        genreLabel.text = show.genres.joined(separator: ", ")
        ratingLabel.text = String(format: "%.1f", show.rating)

        ratingContainer.backgroundColor = RatingColor.color(for: show.rating)

        // Отменяем предыдущую задачу если есть
        loadTask?.cancel()
        
        // Устанавливаем плейсхолдер
        posterImageView.image = nil
        posterImageView.backgroundColor = .systemGray5
        currentImageName = show.imageName
        
        // Начинаем асинхронную загрузку
        loadTask = Task { [weak self] in
            guard let self = self else { return }
            
            let image = await RemoteDataSource.shared.loadImage(imageName: show.imageName)
            
            // Проверяем что ячейка все еще показывает тот же фильм и задача не отменена
            guard !Task.isCancelled,
                  self.currentImageName == show.imageName else {
                return
            }
            
            await MainActor.run {
                // Дополнительная проверка на случай если ячейка была переиспользована
                guard self.currentImageName == show.imageName else { return }
                
                self.posterImageView.image = image
                self.posterImageView.backgroundColor = image != nil ? .clear : .systemGray5
            }
        }
    }
}

// MARK: - Setup Methods

private extension ShowCell {

    func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupInfoLabel()
        setupGenreLabel()
        setupRatingLabel()
        setupRatingContainer()
        setupTextStack()
        setupMainContainer()
        addSubviews()
    }

    func setupConstraints() {
        setupImageViewConstraints()
        setupMainContainerConstraints()
        setupTextStackConstraints()
        setupRatingContainerConstraints()
        setupRatingLabelConstraints()
    }

    func setupImageView() {
        posterImageView.contentMode = .scaleToFill
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .systemGray5
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupInfoLabel() {
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.textColor = .lightGray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupGenreLabel() {
        genreLabel.font = .systemFont(ofSize: 14)
        genreLabel.textColor = .lightGray
        genreLabel.numberOfLines = 2
        genreLabel.lineBreakMode = .byTruncatingTail
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupRatingLabel() {
        ratingLabel.font = .boldSystemFont(ofSize: 16)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupRatingContainer() {
        ratingContainer.layer.cornerRadius = 12
        ratingContainer.clipsToBounds = true
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.addSubview(ratingLabel)
    }

    func setupTextStack() {
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(infoLabel)
        textStack.addArrangedSubview(genreLabel)
    }

    func setupMainContainer() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(textStack)
        mainContainer.addSubview(ratingContainer)
    }

    func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(mainContainer)
    }

    func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupMainContainerConstraints() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContainer.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor)
        ])
    }

    func setupTextStackConstraints() {
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            textStack.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            textStack.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: ratingContainer.topAnchor, constant: -8)
        ])
    }

    func setupRatingContainerConstraints() {
        NSLayoutConstraint.activate([
            ratingContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            ratingContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }

    func setupRatingLabelConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor, constant: 12),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainer.trailingAnchor, constant: -12),
            ratingLabel.topAnchor.constraint(equalTo: ratingContainer.topAnchor, constant: 4),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor, constant: -4)
        ])
    }
}
