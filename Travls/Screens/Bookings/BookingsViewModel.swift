import SwiftUI
import Combine

@MainActor
final class BookingsViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var selectedStatus: BookingStatus = .upcoming
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let network = NetworkClient.shared

    var filteredBookings: [Booking] {
        bookings.filter { $0.status == selectedStatus }
    }

    func loadBookings() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // bookings = try await network.request(BookingsEndpoints.myBookings)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }
}
