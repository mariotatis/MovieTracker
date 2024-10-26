import Foundation
import SwiftUI

class MovieStore: ObservableObject {
    @Published var movies: [Movie] = []
    private let saveKey = "SavedMovies"
    
    init() {
        load()
    }
    
    func add(_ movie: Movie) {
        movies.append(movie)
        save()
    }
    
    func remove(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        save()
    }
    
    func toggleWatched(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isWatched.toggle()
            movies[index].isWatchNext = false
            save()
        }
    }
    
    func toggleWatchNext(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isWatchNext.toggle()
            movies[index].isWatched = false
            save()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decoded
        }
    }
}