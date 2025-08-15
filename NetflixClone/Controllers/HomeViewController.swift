//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var playButton: MainActionButton!
    @IBOutlet weak var myListButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var movies: [Movie] = []
    private var featuredMovie: Movie?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovies()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupNavigationBar()
        setupHeroSection()
        setupCollectionView()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupHeroSection() {
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        
        heroTitleLabel.textColor = .white
        heroTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        heroTitleLabel.textAlignment = .center
        
        heroDescriptionLabel.textColor = .lightGray
        heroDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        heroDescriptionLabel.textAlignment = .center
        heroDescriptionLabel.numberOfLines = 3
    }
    
    private func setupButtons() {
        // Main play button - now uses blue color from MainActionButton class
        playButton.setTitle("▶ Play", for: .normal)
        
        // My List button
        myListButton.setTitle("+ My List", for: .normal)
        myListButton.setTitleColor(.white, for: .normal)
        myListButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        myListButton.layer.cornerRadius = 8
        myListButton.layer.borderWidth = 1
        myListButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        // Register cell
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        // Setup layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    // MARK: - Data Loading
    private func loadMovies() {
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.movies = MockData.getMovies()
            self?.featuredMovie = self?.movies.first
            self?.updateHeroSection()
            self?.collectionView.reloadData()
        }
    }
    
    private func updateHeroSection() {
        guard let movie = featuredMovie else { return }
        
        heroTitleLabel.text = movie.title
        heroDescriptionLabel.text = movie.description
        
        // Load hero image
        if let imageUrl = URL(string: movie.posterURL) {
            loadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.heroImageView.image = image
                }
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
    
    // MARK: - Actions
    @IBAction func playButtonTapped(_ sender: MainActionButton) {
        guard let movie = featuredMovie else { return }
        playMovie(movie)
    }
    
    @IBAction func myListButtonTapped(_ sender: UIButton) {
        guard let movie = featuredMovie else { return }
        addToMyList(movie)
    }
    
    private func playMovie(_ movie: Movie) {
        let playerVC = PlayerViewController()
        playerVC.movie = movie
        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true)
    }
    
    private func addToMyList(_ movie: Movie) {
        // Add to favorites/my list logic
        let alert = UIAlertController(title: "Added to My List", 
                                    message: "\(movie.title) has been added to your list.", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        playMovie(movie)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
}