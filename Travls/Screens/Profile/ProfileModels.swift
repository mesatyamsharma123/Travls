import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String
    let name: String
    let email: String?
    let phone: String
    let avatarURL: String?
    let joinedDate: Date
    let totalTrips: Int
    let countriesVisited: Int
}
