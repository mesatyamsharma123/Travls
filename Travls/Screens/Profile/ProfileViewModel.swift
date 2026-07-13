import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let network = NetworkClient.shared
    private let appSession: AppSession

    init(appSession: AppSession) {
        self.appSession = appSession
    }

    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // profile = try await network.request(ProfileEndpoints.me)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }

    func logout() {
        appSession.logout()
    }
}
