//
//  MainViewController.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class MainViewController: UIViewController {

    private let tableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Table View", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Collection View", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Components"
        view.backgroundColor = .red
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        view.addSubview(tableButton)
        view.addSubview(collectionButton)

        NSLayoutConstraint.activate([
            tableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            tableButton.widthAnchor.constraint(equalToConstant: 200),
            tableButton.heightAnchor.constraint(equalToConstant: 50),

            collectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionButton.topAnchor.constraint(equalTo: tableButton.bottomAnchor, constant: 20),
            collectionButton.widthAnchor.constraint(equalToConstant: 200),
            collectionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        tableButton.addTarget(self, action: #selector(openTable), for: .touchUpInside)
        collectionButton.addTarget(self, action: #selector(openCollection), for: .touchUpInside)
    }

    @objc private func openTable() {
        let vc = TableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openCollection() {
        let vc = CollectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
