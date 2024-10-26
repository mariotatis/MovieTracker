import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var movieStore: MovieStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster Image
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                }
                .shadow(radius: 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Title and Type
                    HStack {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text(movie.mediaType == .movie ? "Movie" : "TV Show")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                    
                    // Release Date and Rating
                    HStack {
                        if let releaseDate = movie.releaseDate {
                            Label(releaseDate, systemImage: "calendar")
                        }
                        Spacer()
                        Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .font(.subheadline)
                    
                    // Watch Status Buttons
                    HStack(spacing: 12) {
                        Button(action: { movieStore.toggleWatched(movie) }) {
                            Text(movie.isWatched ? "Watched" : "Watch")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(movie.isWatched ? .green : .blue)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(movie.isWatched ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                                )
                        }
                        
                        Button(action: { movieStore.toggleWatchNext(movie) }) {
                            Text(movie.isWatchNext ? "Next" : "Next")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(movie.isWatchNext ? .orange : .blue)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(movie.isWatchNext ? Color.orange.opacity(0.2) : Color.blue.opacity(0.1))
                                )
                        }
                    }
                    
                    // Overview
                    Text("Overview")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}