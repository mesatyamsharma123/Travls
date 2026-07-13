import SwiftUI
import Combine

enum AuthStep {
    case phoneInput
    case otpVerification
    case profileSetup
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var step: AuthStep = .phoneInput
    @Published var phone = ""
    @Published var countryCode = "+91"
    @Published var otp = ""
    @Published var name = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let network = NetworkClient.shared
    private let appSession: AppSession

    init(appSession: AppSession) {
        self.appSession = appSession
    }

    func requestOTP() async {
        guard !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a valid phone number."
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // let _: EmptyResponse = try await network.request(AuthEndpoints.requestOTP(phone: phone, countryCode: countryCode))
            step = .otpVerification
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }

    func verifyOTP() async {
        guard otp.count == 4 else {
            errorMessage = "Please enter the 4-digit OTP."
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // let response: AuthResponse = try await network.request(AuthEndpoints.verifyOTP(phone: phone, otp: otp))
            // if response.isNewUser { step = .profileSetup } else { appSession.login(...) }
            step = .profileSetup
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }

    func completeProfile() async {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your name."
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // let response: AuthResponse = try await network.request(AuthEndpoints.register(...))
            // appSession.login(accessToken: response.accessToken, refreshToken: response.refreshToken, userId: response.userId, userName: name)
            appSession.login(accessToken: "mock_token", refreshToken: nil, userId: "mock_user", userName: name)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }
}
