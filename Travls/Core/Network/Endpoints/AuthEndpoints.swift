// NetworkManager/Endpoints/AuthEndpoints.swift

import Foundation

enum AuthEndpoints {
    private static var base: String { Configuration.shared.environment.baseURL }

    static func googleAuth(idToken: String) throws -> APIRequest {
        try APIRequest(
            urlString: "\(base)/auth/google",
            method: .post,
            auth: .none,
            body: ["idToken": idToken]
        )
    }

    static func appleAuth(identityToken: String) throws -> APIRequest {
        try APIRequest(
            urlString: "\(base)/auth/apple",
            method: .post,
            auth: .none,
            body: ["identityToken": identityToken]
        )
    }
}
