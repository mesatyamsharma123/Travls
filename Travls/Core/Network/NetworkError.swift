// NetworkManager/Core/NetworkError.swift

import Foundation

enum NetworkError: LocalizedError {

    // MARK: - Client-side
    case invalidURL
    case invalidResponse
    case noInternet
    case connectionLost
    case encodingFailed
    case decodingFailed
    case imageConversionFailed

    // MARK: - 4xx
    case badRequest(String)
    case unauthorized
    case forbidden
    case notFound
    case conflict
    case unprocessable
    case tooManyRequests

    // MARK: - 5xx
    case internalServerError
    case serviceUnavailable
    case gatewayTimeout

    // MARK: - Fallback
    case httpError(statusCode: Int, message: String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "The URL is invalid."
        case .invalidResponse:          return "Received an invalid response from the server."
        case .noInternet:               return "No internet connection. Please check your network and try again."
        case .connectionLost:           return "Network connection was lost. Please try again."
        case .encodingFailed:           return "Failed to encode the request. Please try again."
        case .decodingFailed:           return "Failed to process the server response. Please try again."
        case .imageConversionFailed:    return "Failed to process the image. Please try again."
        case .badRequest(let msg):      return msg.isEmpty ? "Invalid request. Please check your input." : msg
        case .unauthorized:             return "Your session has expired. Please sign in again."
        case .forbidden:                return "You don't have permission to perform this action."
        case .notFound:                 return "The requested resource was not found."
        case .conflict:                 return "A conflict occurred. Please try again."
        case .unprocessable:            return "The request could not be processed. Please check your input."
        case .tooManyRequests:          return "Too many requests. Please wait a moment and try again."
        case .internalServerError:      return "A server error occurred. Please try again later."
        case .serviceUnavailable:       return "The service is temporarily unavailable. Please try again later."
        case .gatewayTimeout:           return "The server took too long to respond. Please try again."
        case .httpError(_, let msg):    return msg.isEmpty ? "An unexpected error occurred." : msg
        case .unknown(let err):         return err.localizedDescription
        }
    }
}
