import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: AuthViewModel

    init(appSession: AppSession) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(appSession: appSession))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                TravlsTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: TravlsTheme.Spacing.xl) {
                    Spacer()

                    VStack(spacing: TravlsTheme.Spacing.sm) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(TravlsTheme.Colors.primary)

                        Text("Travls")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(TravlsTheme.Colors.textPrimary)
                    }

                    Spacer()

                    switch viewModel.step {
                    case .phoneInput:
                        phoneInputSection
                    case .otpVerification:
                        otpSection
                    case .profileSetup:
                        profileSetupSection
                    }

                    Spacer()
                }
                .padding(.horizontal, TravlsTheme.Spacing.lg)
            }
        }
        .animation(.easeInOut(duration: Constants.Animation.defaultDuration), value: viewModel.step)
    }

    private var phoneInputSection: some View {
        VStack(spacing: TravlsTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.sm) {
                Text("Enter your phone number")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)

                Text("We'll send you a verification code")
                    .font(.system(size: 14))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: TravlsTheme.Spacing.sm) {
                Text(viewModel.countryCode)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)
                    .padding(.horizontal, TravlsTheme.Spacing.md)
                    .frame(height: 52)
                    .background(TravlsTheme.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))

                TextField("Phone number", text: $viewModel.phone)
                    .keyboardType(.phonePad)
                    .font(.system(size: 16))
                    .padding(.horizontal, TravlsTheme.Spacing.md)
                    .frame(height: 52)
                    .background(TravlsTheme.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButton(title: "Send OTP", isLoading: viewModel.isLoading) {
                Task { await viewModel.requestOTP() }
            }
        }
    }

    private var otpSection: some View {
        VStack(spacing: TravlsTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.sm) {
                Text("Verify your number")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)

                Text("Enter the 4-digit code sent to \(viewModel.countryCode) \(viewModel.phone)")
                    .font(.system(size: 14))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TextField("0000", text: $viewModel.otp)
                .keyboardType(.numberPad)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(TravlsTheme.Spacing.md)
                .frame(height: 64)
                .background(TravlsTheme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))
                .onChange(of: viewModel.otp) { _, new in
                    if new.count > 4 { viewModel.otp = String(new.prefix(4)) }
                }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.error)
            }

            PrimaryButton(title: "Verify", isLoading: viewModel.isLoading) {
                Task { await viewModel.verifyOTP() }
            }

            Button("Change number") { viewModel.step = .phoneInput }
                .font(.system(size: 14))
                .foregroundStyle(TravlsTheme.Colors.primary)
        }
    }

    private var profileSetupSection: some View {
        VStack(spacing: TravlsTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.sm) {
                Text("What's your name?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)

                Text("Help us personalise your experience")
                    .font(.system(size: 14))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Your name", text: $viewModel.name)
                .font(.system(size: 16))
                .padding(.horizontal, TravlsTheme.Spacing.md)
                .frame(height: 52)
                .background(TravlsTheme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButton(title: "Get Started", isLoading: viewModel.isLoading) {
                Task { await viewModel.completeProfile() }
            }
        }
    }
}
