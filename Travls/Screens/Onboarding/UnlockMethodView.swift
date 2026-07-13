import SwiftUI

struct UnlockMethodView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var isAuthenticating = false

    private let gold    = Color(hex: "#F2C94C")
    private let surface = Color(hex: "#1C1C1C")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Top
                HStack {
                    Button {
                        appSession.proceedToConfirmPIN("") // won't match, edge case handled
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // 3 gold dots
                HStack(spacing: 8) {
                    Circle().fill(gold).frame(width: 8, height: 8)
                    Circle().fill(gold).frame(width: 8, height: 8)
                    Circle().fill(gold).frame(width: 8, height: 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 40)

                // Title
                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose Your Unlock\nMethod")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .lineSpacing(2)

                    Text("Choose how you'd like to unlock Travls. You\ncan change this anytime in Settings.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#6B6B6B"))
                        .lineSpacing(3)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // PIN Only card
                Button {
                    appSession.login(accessToken: "mock_google_token", refreshToken: nil, userId: "mock_user", userName: "Traveller")
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("PIN Only")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                            Text("Enter your 6-digit PIN each\ntime you open the app.")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#6B6B6B"))
                                .lineSpacing(3)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        ZStack {
                            Circle().fill(Color(hex: "#2A2A2A")).frame(width: 52, height: 52)
                            Image(systemName: "square.grid.3x3.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(hex: "#6B6B6B"))
                        }
                    }
                    .padding(20)
                    .background(surface)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Face ID card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Face ID")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                            Text("Unlock instantly with Face ID\n— no PIN needed")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#6B6B6B"))
                                .lineSpacing(3)
                        }
                        Spacer()
                        ZStack {
                            Circle().fill(gold.opacity(0.2)).frame(width: 52, height: 52)
                            Image(systemName: "faceid")
                                .font(.system(size: 22))
                                .foregroundStyle(gold)
                        }
                    }

                    Button {
                        Task {
                            isAuthenticating = true
                            let success = await BiometricManager.shared.authenticateWithFaceID()
                            isAuthenticating = false
                            if success {
                                UserDefaultsHelper.shared.set(true, key: .useFaceID)
                                appSession.login(accessToken: "mock_google_token", refreshToken: nil, userId: "mock_user", userName: "Traveller")
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if isAuthenticating {
                                ProgressView().tint(.black)
                            } else {
                                Image(systemName: "faceid")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.black)
                                Text("Enable Face ID Unlock")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(gold)
                        .clipShape(Capsule())
                    }
                    .disabled(isAuthenticating)
                }
                .padding(20)
                .background(Color(hex: "#1E1A0E"))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

#Preview { UnlockMethodView().environmentObject(AppSession()) }
