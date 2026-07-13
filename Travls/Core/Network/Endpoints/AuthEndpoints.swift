import Foundation

enum AuthEndpoints: APIEndpoint {
    case requestOTP(phone: String, countryCode: String)
    case verifyOTP(phone: String, otp: String)
    case register(userId: String, name: String, email: String?)
    case refreshToken(token: String)

    var path: String {
        switch self {
        case .requestOTP:   return "/auth/request-otp"
        case .verifyOTP:    return "/auth/verify-otp"
        case .register:     return "/auth/register"
        case .refreshToken: return "/auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .requestOTP, .verifyOTP, .register, .refreshToken: return .post
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .requestOTP, .verifyOTP, .register, .refreshToken: return false
        }
    }

    var body: Encodable? {
        switch self {
        case .requestOTP(let phone, let cc):
            return ["phone": phone, "countryCode": cc]
        case .verifyOTP(let phone, let otp):
            return ["phone": phone, "otp": otp]
        case .register(let userId, let name, let email):
            var payload: [String: String] = ["userId": userId, "name": name]
            if let email { payload["email"] = email }
            return payload
        case .refreshToken(let token):
            return ["refreshToken": token]
        }
    }
}
