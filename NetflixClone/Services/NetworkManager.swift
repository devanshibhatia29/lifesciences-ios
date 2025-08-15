import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchTrendingMovies() -> AnyPublisher<MoviesResponse, Error>
    func fetchPopularMovies() -> AnyPublisher<MoviesResponse, Error>
    func fetchTopRatedMovies() -> AnyPublisher<MoviesResponse, Error>
    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, Error>
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let apiKey = "YOUR_TMDB_API_KEY"
    private let baseURL = "https://api.themoviedb.org/3"
    private let session: URLSession
    
    // For testing - allow injection of custom URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func createURL(endpoint: String, queryItems: [URLQueryItem] = []) -> URL? {
        guard var components = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            return nil
        }
        
        var defaultQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        defaultQueryItems.append(contentsOf: queryItems)
        components.queryItems = defaultQueryItems
        
        return components.url
    }
    
    private func performRequest<T: Codable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: responseType, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTrendingMovies() -> AnyPublisher<MoviesResponse, Error> {
        guard let url = createURL(endpoint: "trending/movie/day") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: MoviesResponse.self)
    }
    
    func fetchPopularMovies() -> AnyPublisher<MoviesResponse, Error> {
        guard let url = createURL(endpoint: "movie/popular") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: MoviesResponse.self)
    }
    
    func fetchTopRatedMovies() -> AnyPublisher<MoviesResponse, Error> {
        guard let url = createURL(endpoint: "movie/top_rated") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: MoviesResponse.self)
    }
    
    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, Error> {
        let queryItems = [URLQueryItem(name: "query", value: query)]
        guard let url = createURL(endpoint: "search/movie", queryItems: queryItems) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: MoviesResponse.self)
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}

// Mock Network Manager for testing
class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockMovies: [Movie] = []
    
    init() {
        // Initialize with default mock data
        resetToDefaultState()
    }
    
    func resetToDefaultState() {
        shouldReturnError = false
        mockMovies = [
            Movie.mockMovie(id: 1, title: "Trending Movie 1"),
            Movie.mockMovie(id: 2, title: "Trending Movie 2"),
            Movie.mockMovie(id: 3, title: "Popular Movie 1"),
            Movie.mockMovie(id: 4, title: "Top Rated Movie 1")
        ]
    }
    
    private func createMockResponse() -> AnyPublisher<MoviesResponse, Error> {
        if shouldReturnError {
            return Fail(error: NetworkError.noData)
                .eraseToAnyPublisher()
        }
        
        let response = MoviesResponse(
            page: 1,
            results: mockMovies,
            totalPages: 1,
            totalResults: mockMovies.count
        )
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTrendingMovies() -> AnyPublisher<MoviesResponse, Error> {
        return createMockResponse()
    }
    
    func fetchPopularMovies() -> AnyPublisher<MoviesResponse, Error> {
        return createMockResponse()
    }
    
    func fetchTopRatedMovies() -> AnyPublisher<MoviesResponse, Error> {
        return createMockResponse()
    }
    
    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, Error> {
        let filteredMovies = mockMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        let response = MoviesResponse(
            page: 1,
            results: filteredMovies,
            totalPages: 1,
            totalResults: filteredMovies.count
        )
        
        if shouldReturnError {
            return Fail(error: NetworkError.noData)
                .eraseToAnyPublisher()
        }
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}