import Foundation

struct SearchFilter: Equatable {
    var query: String = ""
    var category: TripCategory? = nil
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var minRating: Double? = nil

    var isEmpty: Bool { query.isEmpty && category == nil && minPrice == nil && maxPrice == nil }
}

enum TripCategory: String, CaseIterable, Identifiable {
    case beach      = "Beach"
    case mountain   = "Mountain"
    case city       = "City"
    case adventure  = "Adventure"
    case culture    = "Culture"
    case wildlife   = "Wildlife"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .beach:     return "sun.max"
        case .mountain:  return "mountain.2"
        case .city:      return "building.2"
        case .adventure: return "figure.hiking"
        case .culture:   return "building.columns"
        case .wildlife:  return "pawprint"
        }
    }
}

struct SearchResult: Identifiable, Codable {
    let id: String
    let type: String
    let title: String
    let subtitle: String
    let imageURL: String
    let price: Double?
    let currency: String?
    let rating: Double?
}
