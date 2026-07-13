import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var featuredDestinations: [Destination] = []
    @Published var trendingTrips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let network = NetworkClient.shared

    func loadHome() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // featuredDestinations = try await network.request(HomeEndpoints.featured)
            // trendingTrips = try await network.request(HomeEndpoints.trending)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }
}
