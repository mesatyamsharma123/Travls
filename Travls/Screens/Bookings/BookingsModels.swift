import Foundation

enum BookingStatus: String, Codable {
    case upcoming  = "upcoming"
    case ongoing   = "ongoing"
    case completed = "completed"
    case cancelled = "cancelled"
}

struct Booking: Identifiable, Codable {
    let id: String
    let tripTitle: String
    let destinationName: String
    let imageURL: String
    let startDate: Date
    let endDate: Date
    let totalPrice: Double
    let currency: String
    let status: BookingStatus
    let passengerCount: Int
}
