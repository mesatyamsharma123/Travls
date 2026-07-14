import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - Existing published properties (preserved for API compatibility)
    @Published var profile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - New published properties for the redesigned Profile UI
    @Published var displayModel: ProfileDisplayModel?
    @Published var isNotificationsEnabled: Bool = true
    @Published var isBiometricsEnabled: Bool = true

    // MARK: - Static UI data (comes from ViewModel, never hardcoded in View)
    let generalItems: [ProfileMenuItem] = [
        ProfileMenuItem(
            icon: "person.fill",
            title: "Personal Info",
            subtitle: "Name, Email, Phone"
        ),
        ProfileMenuItem(
            icon: "questionmark.circle.fill",
            title: "Support",
            subtitle: "Help Center, Live Chat"
        )
    ]

    let versionBadge      = "v1.0.1"
    let bottomVersionText = "TRAVLS V2.4.1 (BETA)"

    // MARK: - Private
    private let network    = NetworkClient.shared
    private let appSession: AppSession

    init(appSession: AppSession) {
        self.appSession = appSession
    }

    // MARK: - Data loading
    // Replace the mock line with a real network.request(...) call when the backend is ready.
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // TODO: Uncomment and wire real endpoint
            // profile = try await network.request(ProfileEndpoints.me)
            // displayModel = ProfileDisplayModel(from: profile!)
            displayModel = mockDisplayModel()
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }

    // MARK: - Actions
    func editProfile() {
        // TODO: Navigate to Edit Profile screen
        print("TODO: Navigate to Edit Profile")
    }

    func openPersonalInfo() {
        // TODO: Navigate to Personal Info screen
        print("TODO: Navigate to Personal Info")
    }

    func openSupport() {
        // TODO: Navigate to Support screen
        print("TODO: Navigate to Support")
    }

    func logout() {
        appSession.logout()
    }

    // MARK: - Mock
    private func mockDisplayModel() -> ProfileDisplayModel {
        let dob = Calendar.current.date(
            from: DateComponents(year: 2004, month: 3, day: 12)
        ) ?? Date()
        return ProfileDisplayModel(
            id: "mock_user_001",
            username: "candy_boy_ss",
            email: "officialsumitraj993905@gmail.com",
            dateOfBirth: dob,
            avatarURL: nil,
            coverImageURL: nil
        )
    }
}
