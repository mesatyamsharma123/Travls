import SwiftUI
import Combine

// enum AuthStep {
//     case phoneInput        // PHONE LOGIN - NOT NEEDED
//     case otpVerification   // PHONE LOGIN - NOT NEEDED
//     case profileSetup      // PHONE LOGIN - NOT NEEDED
// }

@MainActor
final class AuthViewModel: ObservableObject {
    // @Published var step: AuthStep = .phoneInput     // PHONE LOGIN - NOT NEEDED
    // @Published var phone = ""                        // PHONE LOGIN - NOT NEEDED
    // @Published var countryCode = "+91"               // PHONE LOGIN - NOT NEEDED
    // @Published var otp = ""                          // PHONE LOGIN - NOT NEEDED
    // @Published var name = ""                         // PHONE LOGIN - NOT NEEDED

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let network = NetworkClient.shared
    private let appSession: AppSession

    init(appSession: AppSession) {
        self.appSession = appSession
    }

    // PHONE LOGIN - NOT NEEDED
    // func requestOTP() async {
    //     guard !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
    //         errorMessage = "Please enter a valid phone number."
    //         return
    //     }
    //     isLoading = true
    //     errorMessage = nil
    //     defer { isLoading = false }
    //     do {
    //         // let _: EmptyResponse = try await network.request(AuthEndpoints.requestOTP(phone: phone, countryCode: countryCode))
    //         step = .otpVerification
    //     } catch {
    //         errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
    //     }
    // }

    // PHONE LOGIN - NOT NEEDED
    // func verifyOTP() async {
    //     guard otp.count == 4 else {
    //         errorMessage = "Please enter the 4-digit OTP."
    //         return
    //     }
    //     isLoading = true
    //     errorMessage = nil
    //     defer { isLoading = false }
    //     do {
    //         // let response: AuthResponse = try await network.request(AuthEndpoints.verifyOTP(phone: phone, otp: otp))
    //         // if response.isNewUser { step = .profileSetup } else { appSession.login(...) }
    //         step = .profileSetup
    //     } catch {
    //         errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
    //     }
    // }

    // PHONE LOGIN - NOT NEEDED
    // func completeProfile() async {
    //     guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
    //         errorMessage = "Please enter your name."
    //         return
    //     }
    //     isLoading = true
    //     errorMessage = nil
    //     defer { isLoading = false }
    //     do {
    //         // appSession.login(...)
    //     } catch {
    //         errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
    //     }
    // }

    func signInWithGoogle() async {
        appSession.startSigningIn()
        // TODO: Real Google Sign-In SDK
        // let googleUser = try await GoogleSignIn.signIn()
        // let credential = try await network.request(AuthEndpoints.googleAuth(idToken: googleUser.idToken))
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        print("All good")
        if PINManager.shared.hasPIN() {
            appSession.login(accessToken: "mock_google_token", refreshToken: nil, userId: "mock_user", userName: "Traveller")
        } else {
            appSession.proceedToPINSetup()
        }
    }

    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            // TODO: Implement Apple Sign-In
            // let appleCredential = try await AppleSignIn.signIn()
            // let credential = try await network.request(AuthEndpoints.appleAuth(identityToken: appleCredential.identityToken))
            // appSession.login(accessToken: credential.accessToken, refreshToken: credential.refreshToken, userId: credential.userId, userName: appleCredential.fullName)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
    }
}
