//
//  MovieCollectionViewCell.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    public func configure(with posterURL: String?) {
        // Load image from URL
        // Implementation would include image loading logic
        posterImageView.image = UIImage(named: "placeholder")
    }
}