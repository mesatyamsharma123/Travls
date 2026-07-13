import Foundation

enum NetworkError: LocalizedError {
    case noInternet
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(Int)
    case statusCode(Int)
    case decodingFailed(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .noInternet:          return "No internet connection."
        case .invalidURL:          return "Invalid request URL."
        case .invalidResponse:     return "Invalid server response."
        case .unauthorized:        return "Session expired. Please log in again."
        case .notFound:            return "The requested resource was not found."
        case .serverError(let c):  return "Server error (\(c))."
        case .statusCode(let c):   return "Unexpected status code (\(c))."
        case .decodingFailed:      return "Failed to parse server response."
        case .unknown(let e):      return e.localizedDescription
        }
    }
}
