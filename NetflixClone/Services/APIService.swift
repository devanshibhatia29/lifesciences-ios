//
//  APIService.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Validate API keys on initialization
        if !APIConfiguration.shared.validateAPIKeys() {
            print("⚠️ Warning: API keys not properly configured")
        }
    }
    
    // MARK: - TMDB API Methods
    
    func fetchTrendingMovies() -> AnyPublisher<TMDBResponse, Error> {
        let urlString = "\(APIConfiguration.shared.tmdbBaseURL)/trending/movie/day?api_key=\(APIConfiguration.shared.tmdbAPIKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TMDBResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPopularMovies() -> AnyPublisher<TMDBResponse, Error> {
        let urlString = "\(APIConfiguration.shared.tmdbBaseURL)/movie/popular?api_key=\(APIConfiguration.shared.tmdbAPIKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TMDBResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) -> AnyPublisher<TMDBResponse, Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(APIConfiguration.shared.tmdbBaseURL)/search/movie?api_key=\(APIConfiguration.shared.tmdbAPIKey)&query=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TMDBResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Claude API Methods
    
    func getMovieRecommendations(for movie: Movie) -> AnyPublisher<ClaudeResponse, Error> {
        guard let url = URL(string: "\(APIConfiguration.shared.claudeBaseURL)/messages") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APIConfiguration.shared.claudeAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let prompt = "Based on the movie '\(movie.title)', recommend 5 similar movies. Provide just the movie titles in a simple list format."
        
        let requestBody = ClaudeRequest(
            model: "claude-3-sonnet-20240229",
            maxTokens: 1000,
            messages: [
                ClaudeMessage(role: "user", content: prompt)
            ]
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ClaudeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func testClaudeAPIConnection() -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "\(APIConfiguration.shared.claudeBaseURL)/messages") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APIConfiguration.shared.claudeAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let testRequest = ClaudeRequest(
            model: "claude-3-sonnet-20240229",
            maxTokens: 10,
            messages: [
                ClaudeMessage(role: "user", content: "Hello")
            ]
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(testRequest)
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .map { _ in true }
            .mapError { error in
                print("Claude API Test Failed: \(error.localizedDescription)")
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - API Error Types

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    case apiKeyMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return "Network error: \(message)"
        case .apiKeyMissing:
            return "API key is missing or invalid"
        }
    }
}