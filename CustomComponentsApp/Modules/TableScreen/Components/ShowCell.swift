//
//  ShowCell.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 01.11.2025.
//

import UIKit

final class ShowCell: UITableViewCell {

    // MARK: - UI Elements

    private let colorView = UIView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingContainer = UIView()
    private let ratingLabel = UILabel()
    private let textStack = UIStackView()
    private let mainContainer = UIView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with show: Show) {
        titleLabel.text = show.title
        infoLabel.text = "\(show.year) • \(show.country)"
        genreLabel.text = show.genres.joined(separator: ", ")
        ratingLabel.text = String(format: "%.1f", show.rating)

        ratingContainer.backgroundColor = RatingColor.color(for: show.rating)

        colorView.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}

// MARK: - Setup Methods

private extension ShowCell {

    func setupViews() {
        setupColorView()
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
        setupColorViewConstraints()
        setupMainContainerConstraints()
        setupTextStackConstraints()
        setupRatingContainerConstraints()
        setupRatingLabelConstraints()
    }

    func setupColorView() {
        colorView.layer.cornerRadius = 4
        colorView.clipsToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(colorView)
        contentView.addSubview(mainContainer)
    }

    func setupColorViewConstraints() {
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupMainContainerConstraints() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContainer.topAnchor.constraint(equalTo: colorView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: colorView.bottomAnchor)
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
