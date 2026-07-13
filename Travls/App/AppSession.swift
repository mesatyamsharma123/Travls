import SwiftUI
import Combine

enum AuthState {
    case splash
    case unauthenticated
    case authenticated
}

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var authState: AuthState = .splash

    init() {
        resolveInitialState()
    }

    private func resolveInitialState() {
        if KeychainHelper.shared.read(key: .accessToken) != nil {
            authState = .authenticated
        } else {
            authState = .unauthenticated
        }
    }

    func login(accessToken: String, refreshToken: String?, userId: String, userName: String) {
        KeychainHelper.shared.save(accessToken, key: .accessToken)
        if let refreshToken {
            KeychainHelper.shared.save(refreshToken, key: .refreshToken)
        }
        UserDefaultsHelper.shared.set(userId, key: .userId)
        UserDefaultsHelper.shared.set(userName, key: .userName)
        authState = .authenticated
    }

    func logout() {
        KeychainHelper.shared.deleteAll()
        UserDefaultsHelper.shared.clearAll()
        authState = .unauthenticated
    }
}
