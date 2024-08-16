//
//  ViewController.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/13.
//

import UIKit
import Combine

class GithubUsersViewController: UIViewController {
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        tableView.register(GithubUserCell.self, forCellReuseIdentifier: "GithubUserCell")
        return tableView
    }()
    
    private let viewModel = UsersViewModel()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        binding()
    }
    
    private func binding() {
        viewModel.$users.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.countLabel.text = "Total of \(list.count) items"
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func setupViews() {
        view.addSubview(countLabel)
        view.addSubview(tableView)
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(4)
            make.left.bottom.right.equalToSuperview()
        }
    }
}

// MARK: - Table View
extension GithubUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GithubUserCell", for: indexPath) as? GithubUserCell
        else {
            return UITableViewCell()
        }
        
        let userCellModel = viewModel.users[indexPath.row]
        cell.configure(cellModel: userCellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let login = viewModel.users[safe: indexPath.row]?.name else { return }
        let vc = GithubUserDetailViewController(login: login)
        present(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight {
            viewModel.nextPage()
        }
    }
}
