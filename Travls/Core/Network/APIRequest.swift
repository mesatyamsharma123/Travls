// NetworkManager/Core/APIRequest.swift

import Foundation

struct APIRequest {
    let urlString: String
    let method: HTTPMethod
    let auth: AuthStyle
    let headers: [String: String]
    let queryItems: [String: String]
    let body: Data?

    init(
        urlString: String,
        method: HTTPMethod = .get,
        auth: AuthStyle = .accessToken,
        headers: [String: String] = [:],
        queryItems: [String: String] = [:]
    ) {
        self.urlString = urlString
        self.method = method
        self.auth = auth
        self.headers = headers
        self.queryItems = queryItems
        self.body = nil
    }

    init<B: Encodable>(
        urlString: String,
        method: HTTPMethod,
        auth: AuthStyle = .accessToken,
        headers: [String: String] = [:],
        queryItems: [String: String] = [:],
        body: B
    ) throws {
        self.urlString = urlString
        self.method = method
        self.auth = auth
        self.headers = headers
        self.queryItems = queryItems
        do {
            self.body = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
    }

    // URL-form-encoded body
    init(
        urlString: String,
        method: HTTPMethod,
        auth: AuthStyle = .accessToken,
        headers: [String: String] = [:],
        queryItems: [String: String] = [:],
        formBody: [String: String]
    ) {
        self.urlString = urlString
        self.method = method
        self.auth = auth
        var h = headers
        h["Content-Type"] = "application/x-www-form-urlencoded"
        self.headers = h
        self.queryItems = queryItems
        let encoded = formBody
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        self.body = encoded.data(using: .utf8)
    }
}
