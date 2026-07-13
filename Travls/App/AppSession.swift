import SwiftUI
import Combine

enum AuthState: Equatable {
    case splash
    case unauthenticated
    case signingIn
    case createPIN
    case confirmPIN(String)
    case chooseUnlock
    case authenticated
}

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var authState: AuthState = .splash

    init() {}

    func completeSplash() {
        authState = KeychainHelper.shared.read(key: .accessToken) != nil ? .authenticated : .unauthenticated
    }

    func startSigningIn() { authState = .signingIn }
    func proceedToPINSetup() { authState = .createPIN }
    func proceedToConfirmPIN(_ pin: String) { authState = .confirmPIN(pin) }
    func proceedToUnlockChoice() { authState = .chooseUnlock }

    func login(accessToken: String, refreshToken: String?, userId: String, userName: String) {
        KeychainHelper.shared.save(accessToken, key: .accessToken)
        if let refreshToken { KeychainHelper.shared.save(refreshToken, key: .refreshToken) }
        UserDefaultsHelper.shared.set(userId, key: .userId)
        UserDefaultsHelper.shared.set(userName, key: .userName)
        UserDefaultsHelper.shared.set(true, key: .hasCompletedOnboarding)
        authState = .authenticated
    }

    func logout() {
        KeychainHelper.shared.deleteAll()
        UserDefaultsHelper.shared.clearAll()
        PINManager.shared.clearPIN()
        authState = .unauthenticated
    }
}
