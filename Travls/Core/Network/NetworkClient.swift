import Foundation

final class NetworkClient {
    static let shared = NetworkClient()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.API.timeoutInterval
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(_ endpoint: any APIEndpoint) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }

        let request = try endpoint.asURLRequest()
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(http.statusCode)
        default:
            throw NetworkError.statusCode(http.statusCode)
        }
    }
}
