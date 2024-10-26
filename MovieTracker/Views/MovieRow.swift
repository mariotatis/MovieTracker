import SwiftUI

struct MovieRow: View {
    let movie: Movie
    @ObservedObject var movieStore: MovieStore
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie, movieStore: movieStore)) {
            HStack(spacing: 12) {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(movie.title)
                            .font(.headline)
                        Spacer()
                        Text(movie.mediaType == .movie ? "Movie" : "TV Show")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: { movieStore.toggleWatched(movie) }) {
                            Text(movie.isWatched ? "Watched" : "Watch")
                                .foregroundColor(movie.isWatched ? .green : .blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(movie.isWatched ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                                )
                        }
                        
                        Button(action: { movieStore.toggleWatchNext(movie) }) {
                            Text(movie.isWatchNext ? "Next" : "Next")
                                .foregroundColor(movie.isWatchNext ? .orange : .blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(movie.isWatchNext ? Color.orange.opacity(0.2) : Color.blue.opacity(0.1))
                                )
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}