import Foundation

enum AuthEndpoints: APIEndpoint {
    // PHONE LOGIN - NOT NEEDED
    // case requestOTP(phone: String, countryCode: String)
    // case verifyOTP(phone: String, otp: String)
    // case register(userId: String, name: String, email: String?)
    // case refreshToken(token: String)

    case googleAuth(idToken: String)
    case appleAuth(identityToken: String)

    var path: String {
        switch self {
        case .googleAuth:  return "/auth/google"
        case .appleAuth:   return "/auth/apple"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .googleAuth, .appleAuth: return .post
        }
    }

    var requiresAuth: Bool { false }

    var body: Encodable? {
        switch self {
        case .googleAuth(let idToken):
            return ["idToken": idToken]
        case .appleAuth(let identityToken):
            return ["identityToken": identityToken]
        }
    }
}
