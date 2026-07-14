// NetworkManager/Core/HTTPMethod.swift

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

enum AuthStyle {
    case none
    case accessToken    // x-access-token: <token>
    case bearer         // Authorization: Bearer <token>
    case plain          // Authorization: <token>
}
