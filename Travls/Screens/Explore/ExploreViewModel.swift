import SwiftUI
import Combine

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var filter = SearchFilter()
    @Published var results: [SearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var searchTask: Task<Void, Never>?
    private let network = NetworkClient.shared

    func onSearchChanged() {
        searchTask?.cancel()
        guard !filter.query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await search()
        }
    }

    func search() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // results = try await network.request(ExploreEndpoints.search(filter: filter))
        } catch {
            if !(error is CancellationError) {
                errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            }
        }
    }
}
