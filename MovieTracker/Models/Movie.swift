import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String?
    let voteAverage: Double
    var isWatched: Bool
    var isWatchNext: Bool
    let mediaType: MediaType
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
    
    enum MediaType: String, Codable {
        case movie
        case tv
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case isWatched
        case isWatchNext
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        
        // Handle both movie titles and TV show names
        if let movieTitle = try? container.decode(String.self, forKey: .title) {
            title = movieTitle
        } else {
            title = try container.decode(String.self, forKey: .name)
        }
        
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decode(String.self, forKey: .overview)
        
        // Handle both movie release dates and TV first air dates
        if let movieReleaseDate = try? container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = movieReleaseDate
        } else {
            releaseDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        }
        
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        mediaType = try container.decodeIfPresent(MediaType.self, forKey: .mediaType) ?? .movie
        isWatched = try container.decodeIfPresent(Bool.self, forKey: .isWatched) ?? false
        isWatchNext = try container.decodeIfPresent(Bool.self, forKey: .isWatchNext) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(overview, forKey: .overview)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(mediaType, forKey: .mediaType)
        try container.encode(isWatched, forKey: .isWatched)
        try container.encode(isWatchNext, forKey: .isWatchNext)
    }
    
    init(id: Int, title: String, posterPath: String?, overview: String, releaseDate: String?, voteAverage: Double, mediaType: MediaType = .movie, isWatched: Bool = false, isWatchNext: Bool = false) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.mediaType = mediaType
        self.isWatched = isWatched
        self.isWatchNext = isWatchNext
    }
}