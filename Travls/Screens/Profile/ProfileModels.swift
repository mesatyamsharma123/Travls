import Foundation

// MARK: - Existing model (preserved exactly — drives future API contract)
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

// MARK: - UI-layer model for the redesigned Profile screen
// Separate from UserProfile so the backend contract is never polluted by UI needs.
// When the real API is ready, populate this from the UserProfile response in the ViewModel.
struct ProfileDisplayModel {
    let id: String
    let username: String
    let email: String
    let dateOfBirth: Date
    let avatarURL: String?
    let coverImageURL: String?
}

// MARK: - Menu item used by General section rows
struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}
