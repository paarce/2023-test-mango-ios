//
//  ComicDetailTableViewController.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import UIKit

class ComicDetailTableViewController: UITableViewController {

    private var presenter: ComicDetailPresenter!


    init(presenter: ComicDetailPresenter) {
        self.presenter = presenter
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    // MARK: - Setup

    private func initialSetup() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        self.tableView.register(ComicBasicInfoTableViewCell.self, forCellReuseIdentifier: ComicBasicInfoTableViewCell.identifier)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = presenter.sections[indexPath.row]

        switch section {
        case .basic(let dto):
            let cell = tableView.dequeueReusableCell(withIdentifier: ComicBasicInfoTableViewCell.identifier, for: indexPath) as! ComicBasicInfoTableViewCell
            cell.set(model: dto)
            return cell
        }

    }

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}
