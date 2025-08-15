import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        loadMovies()
    }
    
    func loadMovies() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        let trendingPublisher = networkManager.fetchTrendingMovies()
        let popularPublisher = networkManager.fetchPopularMovies()
        let topRatedPublisher = networkManager.fetchTopRatedMovies()
        
        Publishers.Zip3(trendingPublisher, popularPublisher, topRatedPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] trending, popular, topRated in
                    DispatchQueue.main.async {
                        self?.trendingMovies = trending.results
                        self?.popularMovies = popular.results
                        self?.topRatedMovies = topRated.results
                        self?.isLoading = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        // Clear existing data and reload
        trendingMovies.removeAll()
        popularMovies.removeAll()
        topRatedMovies.removeAll()
        loadMovies()
    }
    
    func resetToInitialState() {
        // Reset all properties to initial state - useful after git reset
        cancellables.removeAll()
        trendingMovies.removeAll()
        popularMovies.removeAll()
        topRatedMovies.removeAll()
        isLoading = false
        errorMessage = nil
    }
    
    deinit {
        cancellables.removeAll()
    }
}