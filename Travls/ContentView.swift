import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appSession: AppSession

    var body: some View {
        switch appSession.authState {
        case .splash:
            SplashView()
        case .unauthenticated:
            AuthView(appSession: appSession)
                .transition(.opacity)
        case .authenticated:
            MainTabView()
                .transition(.opacity)
        }
    }
}
