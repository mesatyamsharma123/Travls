import Foundation

struct Destination: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let country: String
    let imageURL: String
    let tagline: String
    let rating: Double
    let reviewCount: Int
    let priceFrom: Double
    let currency: String
}

struct Trip: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let destinationName: String
    let imageURL: String
    let price: Double
    let currency: String
    let durationDays: Int
    let rating: Double
    let isFeatured: Bool
}
