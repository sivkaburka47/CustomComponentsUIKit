//
//  TableViewController.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class TableViewController: UITableViewController {

    // MARK: - Properties

    private var data: [Show] = [
        Show(title: "Люцифер", year: 1999, country: "США", rating: 9.0, genres: ["драма", "криминал"]),
        Show(title: "Люцифер", year: 1999, country: "США", rating: 6.5, genres: ["фэнтези", "драма"]),
        Show(title: "Люцифер", year: 1999, country: "США", rating: 7.2, genres: ["комедия", "драма"]),
        Show(title: "Люцифер", year: 1999, country: "США", rating: 4.3, genres: ["боевик", "триллер"])
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
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

// MARK: - Setup Methods

private extension TableViewController {

    func setupNavigation() {
        title = "Movies"
    }

    func setupTableView() {
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.register(ShowCell.self, forCellReuseIdentifier: "ShowCell")
    }
}
