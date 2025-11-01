//
//  TableViewController.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class TableViewController: UITableViewController {

    // MARK: - Properties

    private var data: [Show] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        loadShows()
    }
    
    private func loadShows() {
        Task {
            do {
                data = try await RemoteDataSource.shared.fetchShows()
                await MainActor.run {
                    tableView.reloadData()
                }
            } catch {
                print("Ошибка загрузки данных: \(error)")
            }
        }
    }
}

// MARK: - Table View Data Source

extension TableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! ShowCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension TableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < data.count else { continue }
            let show = data[indexPath.row]
            RemoteDataSource.shared.prefetchImage(imageName: show.imageName)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < data.count else { continue }
            let show = data[indexPath.row]
            RemoteDataSource.shared.cancelPrefetch(imageName: show.imageName)
        }
    }
}

// MARK: - Setup Methods

private extension TableViewController {

    func setupNavigation() {
        title = "Movies"
    }

    func setupTableView() {
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.register(ShowCell.self, forCellReuseIdentifier: "ShowCell")
        tableView.prefetchDataSource = self
    }
}
