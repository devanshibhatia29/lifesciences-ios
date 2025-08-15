//
//  MovieModels.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import Foundation

// MARK: - TMDB Response Models

struct TMDBResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let video: Bool
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, video
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "\(APIConfiguration.shared.tmdbImageBaseURL)\(posterPath)"
    }
    
    var backdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "\(APIConfiguration.shared.tmdbImageBaseURL)\(backdropPath)"
    }
}