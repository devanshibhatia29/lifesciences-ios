//
//  Constants.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import UIKit

struct Constants {
    
    // MARK: - Colors
    struct Colors {
        // Updated brand color from Netflix red to blue
        static let primaryColor = UIColor(hex: "#007AFF")
        static let backgroundColor = UIColor.black
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor.lightGray
        static let cardBackground = UIColor.darkGray
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let titleFont = UIFont.boldSystemFont(ofSize: 28)
        static let subtitleFont = UIFont.systemFont(ofSize: 16)
        static let buttonFont = UIFont.boldSystemFont(ofSize: 18)
        static let captionFont = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
    }
    
    // MARK: - Animation Duration
    struct Animation {
        static let short: TimeInterval = 0.2
        static let medium: TimeInterval = 0.3
        static let long: TimeInterval = 0.5
    }
}