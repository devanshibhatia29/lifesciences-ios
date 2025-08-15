//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Developer on 12/15/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var playButton: CustomButton!
    @IBOutlet weak var downloadButton: CustomButton!
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadMovies()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        
        // Setup navigation bar
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = AppColors.whiteColor
        
        // Setup hero section buttons
        playButton.setCustomTitle("▶ Play")
        playButton.backgroundColor = AppColors.primaryBlue
        
        downloadButton.setCustomTitle("↓ Download")
        downloadButton.backgroundColor = AppColors.primaryBlue
        
        // Add button constraints
        playButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonHeight),
            downloadButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonHeight)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = AppColors.backgroundColor
        tableView.separatorStyle = .none
        
        // Register cells
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), 
                          forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    private func loadMovies() {
        // Load movie data
        MovieService.shared.fetchMovies { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func playButtonTapped(_ sender: CustomButton) {
        let playerVC = PlayerViewController()
        present(playerVC, animated: true)
    }
    
    @IBAction func downloadButtonTapped(_ sender: CustomButton) {
        showDownloadAlert()
    }
    
    private func showDownloadAlert() {
        let alert = UIAlertController(title: "Download", 
                                    message: "Movie will be downloaded for offline viewing", 
                                    preferredStyle: .alert)
        
        let downloadAction = UIAlertAction(title: "Download", style: .default) { _ in
            // Handle download logic
            self.startDownload()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(downloadAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func startDownload() {
        // Download implementation
        print("Starting download...")
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Featured, Trending, Popular
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", 
                                                       for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.configure(with: movies, title: "Featured Movies")
        case 1:
            cell.configure(with: movies, title: "Trending Now")
        case 2:
            cell.configure(with: movies, title: "Popular Movies")
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = AppColors.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}