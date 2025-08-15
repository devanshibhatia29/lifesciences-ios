//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let sectionTitles: [String] = [
        "Trending Movies",
        "Popular",
        "Trending TV",
        "Upcoming Movies",
        "Top Rated"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        // Set up Netflix logo in navigation
        let netflixLogo = UILabel()
        netflixLogo.text = "NETFLIX"
        netflixLogo.textColor = .red
        netflixLogo.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: netflixLogo)
        
        // Add profile and cast buttons
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "person.circle"),
                style: .plain,
                target: self,
                action: #selector(profileTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "airplayvideo"),
                style: .plain,
                target: self,
                action: #selector(castTapped)
            )
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cells
        tableView.register(
            CollectionViewTableViewCell.self,
            forCellReuseIdentifier: CollectionViewTableViewCell.identifier
        )
        tableView.register(
            HeroHeaderUIView.self,
            forHeaderFooterViewReuseIdentifier: HeroHeaderUIView.identifier
        )
    }
    
    @objc private func profileTapped() {
        // Handle profile tap
        print("Profile tapped")
    }
    
    @objc private func castTapped() {
        // Handle cast tap
        print("Cast tapped")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier,
            for: indexPath
        ) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        // Configure cell based on section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 450 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            // Hero header for first section
            let headerView = HeroHeaderUIView()
            return headerView
        } else {
            // Section title header
            let headerView = UIView()
            headerView.backgroundColor = .black
            
            let titleLabel = UILabel()
            titleLabel.text = sectionTitles[section]
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
    }
}