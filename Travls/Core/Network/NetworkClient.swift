// NetworkManager/Core/NetworkClient.swift

import Foundation

final class NetworkClient {

    static let shared = NetworkClient()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private var accessToken: String? {
        KeychainHelper.shared.read(key: .accessToken)
    }

    // MARK: - Public API

    func request<T: Decodable>(_ apiRequest: APIRequest) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }
        let urlRequest = try buildURLRequest(from: apiRequest)
        return try await execute(urlRequest)
    }

    func upload<T: Decodable>(
        to urlString: String,
        imageData: Data,
        fieldName: String = "file",
        auth: AuthStyle = .accessToken
    ) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        applyAuth(auth, to: &urlRequest)

        var bodyData = Data()
        bodyData.append(utf8String: "--\(boundary)\r\n")
        bodyData.append(utf8String: "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"image.jpg\"\r\n")
        bodyData.append(utf8String: "Content-Type: image/jpeg\r\n\r\n")
        bodyData.append(imageData)
        bodyData.append(utf8String: "\r\n--\(boundary)--\r\n")

        urlRequest.httpBody = bodyData
        return try await execute(urlRequest)
    }

    // MARK: - Private Helpers

    private func applyGlobalHeaders(to request: inout URLRequest) {
        request.setValue("io.travls.ios", forHTTPHeaderField: "App-Id")
        request.setValue("ios", forHTTPHeaderField: "platform")
        request.setValue(DeviceHelper.deviceId, forHTTPHeaderField: "device-id")
        request.setValue(Configuration.shared.environment.appVersion, forHTTPHeaderField: "Version")
        request.setValue(Configuration.shared.environment.buildNumber, forHTTPHeaderField: "Version-Code")
    }

    private func buildURLRequest(from apiRequest: APIRequest) throws -> URLRequest {
        guard var components = URLComponents(string: apiRequest.urlString) else {
            throw NetworkError.invalidURL
        }

        if !apiRequest.queryItems.isEmpty {
            components.queryItems = apiRequest.queryItems.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue

        if apiRequest.body != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        applyGlobalHeaders(to: &urlRequest)
        applyAuth(apiRequest.auth, to: &urlRequest)
        apiRequest.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpBody = apiRequest.body
        return urlRequest
    }

    private func applyAuth(_ style: AuthStyle, to request: inout URLRequest) {
        guard let token = accessToken else { return }
        switch style {
        case .none:        break
        case .accessToken: request.setValue(token, forHTTPHeaderField: "x-access-token")
        case .bearer:      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .plain:       request.setValue(token, forHTTPHeaderField: "Authorization")
        }
    }

    private func execute<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as NSError {
            switch error.code {
            case NSURLErrorNotConnectedToInternet: throw NetworkError.noInternet
            case NSURLErrorNetworkConnectionLost:  throw NetworkError.connectionLost
            case NSURLErrorCancelled:              throw CancellationError()
            default:                               throw NetworkError.unknown(error)
            }
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            let rawData = data.isEmpty ? Data("{}".utf8) : data
            if let rawJSON = String(data: rawData, encoding: .utf8) {
                print("📥 [NetworkClient] \(http.statusCode) \(urlRequest.url?.path ?? "") → \(rawJSON.prefix(800))")
            }
            let decodeData = sanitizeJSONFloats(rawData)
            do {
                return try JSONDecoder().decode(T.self, from: decodeData)
            } catch let decodeError {
                print("❌ [NetworkClient] Decode error for \(T.self): \(decodeError)")
                throw NetworkError.decodingFailed
            }
        case 400: throw NetworkError.badRequest(extractErrorMessage(from: data))
        case 401:
            print("🔴 [NetworkClient] 401 URL: \(urlRequest.url?.absoluteString ?? "-")")
            throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 404:
            let body = String(data: data, encoding: .utf8) ?? "<empty>"
            print("🔴 [NetworkClient] 404 URL: \(urlRequest.url?.absoluteString ?? "-") | body: \(body)")
            throw NetworkError.notFound
        case 409: throw NetworkError.conflict
        case 422: throw NetworkError.unprocessable
        case 429: throw NetworkError.tooManyRequests
        case 500: throw NetworkError.internalServerError
        case 503: throw NetworkError.serviceUnavailable
        case 504: throw NetworkError.gatewayTimeout
        default:  throw NetworkError.httpError(statusCode: http.statusCode, message: extractErrorMessage(from: data))
        }
    }

    // Replaces numbers with excessive floating-point precision (e.g. 3993.2000000000003)
    // that NSJSONSerialization rejects as "not representable in Swift", causing the entire
    // response to fail even when unrelated fields are valid.
    private func sanitizeJSONFloats(_ data: Data) -> Data {
        guard let json = String(data: data, encoding: .utf8) else { return data }
        guard json.contains(".") else { return data }
        guard let regex = try? NSRegularExpression(pattern: #"-?\d+\.\d{10,}"#) else { return data }
        var result = json
        let matches = regex.matches(in: json, range: NSRange(json.startIndex..., in: json)).reversed()
        for match in matches {
            guard let range = Range(match.range, in: json) else { continue }
            let numStr = String(json[range])
            if let num = Double(numStr) {
                result.replaceSubrange(range, with: String(format: "%.6f", num))
            }
        }
        return Data(result.utf8)
    }

    private func extractErrorMessage(from data: Data) -> String {
        struct WrappedBody: Decodable {
            struct Body: Decodable { let message: String? }
            let body: Body?
        }
        if let r = try? JSONDecoder().decode(WrappedBody.self, from: data),
           let msg = r.body?.message, !msg.isEmpty { return msg }

        struct ArrayMessage: Decodable { let message: [String]? }
        if let r = try? JSONDecoder().decode(ArrayMessage.self, from: data),
           let msg = r.message?.first, !msg.isEmpty { return msg }

        struct StringMessage: Decodable { let message: String? }
        if let r = try? JSONDecoder().decode(StringMessage.self, from: data),
           let msg = r.message, !msg.isEmpty { return msg }

        return "Something went wrong. Please try again."
    }
}

// MARK: - Data multipart helper

private extension Data {
    mutating func append(utf8String string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}
