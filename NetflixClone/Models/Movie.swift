import Foundation

struct Movie: Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let genreIds: [Int]
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult, popularity, video
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
    }
    
    var fullPosterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var fullBackdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }
    
    // For testing purposes - create mock data
    static func mockMovie(id: Int = 1, title: String = "Test Movie") -> Movie {
        return Movie(
            id: id,
            title: title,
            overview: "Test overview for \(title)",
            posterPath: "/test_poster.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 7.5,
            voteCount: 1000,
            genreIds: [28, 12],
            adult: false,
            originalLanguage: "en",
            originalTitle: title,
            popularity: 100.0,
            video: false
        )
    }
}

struct MoviesResponse: Codable {
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