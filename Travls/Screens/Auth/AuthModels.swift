import Foundation

struct OTPRequestBody: Encodable {
    let phone: String
    let countryCode: String
}

struct OTPVerifyBody: Encodable {
    let phone: String
    let otp: String
}

struct RegisterBody: Encodable {
    let userId: String
    let name: String
    let email: String?
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String?
    let userId: String
    let userName: String
    let isNewUser: Bool
}
