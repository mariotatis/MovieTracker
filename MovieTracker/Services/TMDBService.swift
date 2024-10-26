import Foundation

class TMDBService {
    private let apiKey = "ADD YOUR API KEY HERE"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func searchMoviesAndShows(query: String) async throws -> [Movie] {
        let movieResults = try await searchMedia(type: "movie", query: query)
        let tvResults = try await searchMedia(type: "tv", query: query)
        return movieResults + tvResults
    }
    
    private func searchMedia(type: String, query: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/search/\(type)?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(SearchResponse.self, from: data)
        return response.results.map { movie in
            var movieWithType = movie
            if type == "tv" {
                movieWithType = Movie(
                    id: movie.id,
                    title: movie.title,
                    posterPath: movie.posterPath,
                    overview: movie.overview,
                    releaseDate: movie.releaseDate,
                    voteAverage: movie.voteAverage,
                    mediaType: .tv,
                    isWatched: movie.isWatched,
                    isWatchNext: movie.isWatchNext
                )
            }
            return movieWithType
        }
    }
}

struct SearchResponse: Codable {
    let results: [Movie]
}
