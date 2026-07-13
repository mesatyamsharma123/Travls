import SwiftUI

enum AuthInputTab {
    case phone, email
}

struct AuthView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: AuthViewModel

    @State private var selectedTab: AuthInputTab = .email
    @State private var emailInput = ""

    private let gold        = Color(hex: "#F2C94C")
    private let goldButton  = Color(hex: "#8B7A2E")
    private let surface     = Color(hex: "#1C1C1C")
    private let dividerLine = Color(hex: "#2A2A2A")
    private let textGray    = Color(hex: "#6B6B6B")

    init(appSession: AppSession) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(appSession: appSession))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Spacer()

                // MARK: Header
                Text("WELCOME")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(textGray)
                    .tracking(2)
                    .padding(.bottom, 10)

                Text("Sign in to Travls")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 12)

                Text("We'll send a secure 6-digit code to your phone\nor email. No password needed")
                    .font(.system(size: 14))
                    .foregroundStyle(textGray)
                    .lineSpacing(3)
                    .padding(.bottom, 28)

                // MARK: Phone / Email Toggle
                HStack(spacing: 0) {
                    // Phone — SOON (disabled)
                    HStack(spacing: 8) {
                        Image(systemName: "phone")
                            .font(.system(size: 14))
                            .foregroundStyle(textGray)
                        Text("Phone")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textGray)
                        Text("SOON")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(gold)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#2E2510"))
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)

                    // Email — Active
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = .email
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(selectedTab == .email ? .black : textGray)
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(selectedTab == .email ? .black : textGray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(selectedTab == .email ? gold : Color.clear)
                        .clipShape(Capsule())
                        .padding(3)
                    }
                }
                .background(surface)
                .clipShape(Capsule())
                .padding(.bottom, 16)

                // MARK: Email Input
                HStack(spacing: 14) {
                    Image(systemName: "envelope")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(hex: "#9B8B3A"))

                    TextField("", text: $emailInput, prompt:
                        Text("name@example.com")
                            .foregroundColor(Color(hex: "#4A4A4A"))
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 14)

                // MARK: Continue Button
                // NOTE: Email OTP flow — API integration pending
                Button {
                    // TODO: wire up email OTP when backend ready
                    // Task { await viewModel.requestEmailOTP(email: emailInput) }
                } label: {
                    HStack(spacing: 10) {
                        Text("CONTINUE")
                            .font(.system(size: 15, weight: .bold))
                            .tracking(1.5)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(Color(hex: "#1A1200").opacity(0.9))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(goldButton)
                    .clipShape(Capsule())
                }
                .disabled(emailInput.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.bottom, 28)

                // MARK: OR CONTINUE WITH
                HStack(spacing: 14) {
                    Rectangle().fill(dividerLine).frame(height: 1)
                    Text("OR CONTINUE WITH")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color(hex: "#4A4A4A"))
                        .tracking(1.2)
                        .fixedSize()
                    Rectangle().fill(dividerLine).frame(height: 1)
                }
                .padding(.bottom, 20)

                // MARK: Google + Apple
                HStack(spacing: 14) {
                    // Google
                    Button {
                        Task { await viewModel.signInWithGoogle() }
                    } label: {
                        HStack(spacing: 10) {
                            Text("G")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                            Text("Google")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    // Apple
                    Button {
                        Task { await viewModel.signInWithApple() }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(textGray)
                            Text("Apple")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(textGray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.bottom, 24)

                // MARK: Terms
                Text("By continuing, you agree to our Terms and Privacy\nPolicy.")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "#4A4A4A"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    AuthView(appSession: AppSession())
        .environmentObject(AppSession())
}
