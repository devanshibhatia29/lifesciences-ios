//
//  DetailViewController.swift
//  NetflixClone
//
//  Created by Developer on 12/15/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: CustomButton!
    @IBOutlet weak var addToListButton: CustomButton!
    @IBOutlet weak var shareButton: CustomButton!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithMovie()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        
        // Setup labels
        titleLabel.textColor = AppColors.whiteColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        descriptionLabel.textColor = AppColors.secondaryTextColor
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        // Setup buttons with new blue color
        playButton.setCustomTitle("▶ Play")
        playButton.backgroundColor = AppColors.primaryBlue
        
        addToListButton.setCustomTitle("+ My List")
        addToListButton.backgroundColor = AppColors.primaryBlue
        
        shareButton.setCustomTitle("Share")
        shareButton.backgroundColor = AppColors.primaryBlue
        
        // Setup image view
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = AppConstants.cornerRadius
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addToListButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonHeight),
            addToListButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonHeight),
            shareButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonHeight)
        ])
    }
    
    private func configureWithMovie() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        
        // Load movie image
        if let imageUrl = URL(string: movie.imageURL) {
            loadImage(from: imageUrl)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.movieImageView.image = image
            }
        }.resume()
    }
    
    @IBAction func playButtonTapped(_ sender: CustomButton) {
        let playerVC = PlayerViewController()
        playerVC.movie = movie
        present(playerVC, animated: true)
    }
    
    @IBAction func addToListButtonTapped(_ sender: CustomButton) {
        guard let movie = movie else { return }
        
        // Add to favorites/watchlist
        FavoritesManager.shared.addToFavorites(movie)
        
        // Show confirmation
        showAlert(title: "Added to List", message: "\(movie.title) has been added to your list.")
    }
    
    @IBAction func shareButtonTapped(_ sender: CustomButton) {
        guard let movie = movie else { return }
        
        let shareText = "Check out this movie: \(movie.title)"
        let activityVC = UIActivityViewController(activityItems: [shareText], 
                                                applicationActivities: nil)
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}