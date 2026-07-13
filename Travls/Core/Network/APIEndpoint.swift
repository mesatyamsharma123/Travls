import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var queryItems: [URLQueryItem]? { get }
    var requiresAuth: Bool { get }
}

extension APIEndpoint {
    var headers: [String: String]? { nil }
    var body: Encodable? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var requiresAuth: Bool { true }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: Configuration.shared.baseURL, resolvingAgainstBaseURL: true)!
        components.path += path
        components.queryItems = queryItems

        guard let url = components.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = Constants.API.timeoutInterval

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ios", forHTTPHeaderField: "X-Platform")
        request.setValue(Configuration.shared.appVersion, forHTTPHeaderField: "X-App-Version")

        if requiresAuth, let token = KeychainHelper.shared.read(key: .accessToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        return request
    }
}
