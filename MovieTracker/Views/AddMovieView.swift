import SwiftUI

struct AddMovieView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var movieStore: MovieStore
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchText = ""
    
    var movieResults: [Movie] {
        searchViewModel.movies.filter { $0.mediaType == .movie }
    }
    
    var tvResults: [Movie] {
        searchViewModel.movies.filter { $0.mediaType == .tv }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search movies & TV shows...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        Task {
                            await searchViewModel.search(query: searchText)
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(searchText.isEmpty)
                }
                .padding()
                
                ScrollView {
                    if !movieResults.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Movies")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(movieResults) { movie in
                                    MovieGridItem(movie: movie)
                                        .onTapGesture {
                                            movieStore.add(movie)
                                            dismiss()
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    if !tvResults.isEmpty {
                        VStack(alignment: .leading) {
                            Text("TV Shows")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(tvResults) { show in
                                    MovieGridItem(movie: show)
                                        .onTapGesture {
                                            movieStore.add(show)
                                            dismiss()
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Add Movie or TV Show")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

struct MovieGridItem: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(height: 150)
            .cornerRadius(8)
            
            Text(movie.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}