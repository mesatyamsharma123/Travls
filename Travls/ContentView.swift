import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appSession: AppSession

    var body: some View {
        Group {
            switch appSession.authState {
            case .splash:
                SplashView()
            case .unauthenticated:
                AuthView(appSession: appSession)
                    .transition(.opacity)
            case .signingIn:
                SigningInView()
                    .transition(.opacity)
            case .createPIN:
                CreatePINView()
                    .transition(.opacity)
            case .confirmPIN(let pin):
                ConfirmPINView(originalPIN: pin)
                    .transition(.opacity)
            case .chooseUnlock:
                UnlockMethodView()
                    .transition(.opacity)
            case .authenticated:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appSession.authState)
    }
}
