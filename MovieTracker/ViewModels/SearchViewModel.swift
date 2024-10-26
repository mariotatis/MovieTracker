import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let tmdbService = TMDBService()
    
    func search(query: String) async {
        do {
            movies = try await tmdbService.searchMoviesAndShows(query: query)
        } catch {
            print("Search error: \(error)")
        }
    }
}