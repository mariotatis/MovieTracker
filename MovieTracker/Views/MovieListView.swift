import SwiftUI

struct MovieListView: View {
    @StateObject private var movieStore = MovieStore()
    @State private var showingAddMovie = false
    @State private var filterOption: FilterOption = .all
    
    enum FilterOption {
        case all, watched, watchNext
    }
    
    var filteredMovies: [Movie] {
        switch filterOption {
        case .all:
            return movieStore.movies
        case .watched:
            return movieStore.movies.filter { $0.isWatched }
        case .watchNext:
            return movieStore.movies.filter { $0.isWatchNext }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filterOption == .all ? movieStore.movies : filteredMovies) { movie in
                        MovieRow(movie: movie, movieStore: movieStore)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let movieToDelete = filterOption == .all ? movieStore.movies[index] : filteredMovies[index]
                            movieStore.remove(movieToDelete)
                        }
                    }
                    .onMove(perform: filterOption == .all ? { source, destination in
                        movieStore.movies.move(fromOffsets: source, toOffset: destination)
                        movieStore.save()
                    } : nil)
                }
                .listStyle(PlainListStyle())
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddMovie = true }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("All") { filterOption = .all }
                        Button("Watched") { filterOption = .watched }
                        Button("Watch Next") { filterOption = .watchNext }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView(movieStore: movieStore)
            }
        }
    }
}