import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: ProfileViewModel
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @State private var navigateToEditProfile = false

    private let gold        = Color(hex: "#F2C94C")
    private let surface     = Color(hex: "#1A1A1A")
    private let iconSurface = Color(hex: "#2A2A2A")
    private let gray        = Color(hex: "#6B6B6B")
    private let darkRed     = Color(hex: "#2D0A0A")
    private let alertRed    = Color(hex: "#FF3B30")

    init(appSession: AppSession) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(appSession: appSession))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerBar
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 20)

                        coverSection
                            .padding(.horizontal, 20)

                        profileDetailsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        generalSection
                            .padding(.horizontal, 20)
                            .padding(.top, 32)

                        othersSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        logoutButton
                            .padding(.horizontal, 20)
                            .padding(.top, 36)

                        versionFooter
                            .padding(.top, 24)
                            .padding(.bottom, 40)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToEditProfile) {
                EditProfileView()
            }
            .task { await viewModel.loadProfile() }
        }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1E1E1E"))
                        .frame(width: 42, height: 42)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            Spacer()

            Text("Profile")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Text(viewModel.versionBadge)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(gray)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color(hex: "#1E1E1E"))
                .clipShape(Capsule())
        }
    }

    // MARK: - Cover + Avatar + Edit Profile
    private var coverSection: some View {
        VStack(spacing: 0) {
            // Cover image with avatar overlapping its bottom-left edge
            coverImageView
                .overlay(alignment: .bottomLeading) {
                    avatarView
                        .offset(y: 44)   // push avatar half its height below the cover
                }
                .padding(.bottom, 44)    // allocate space for avatar overflow

            // Edit Profile button — right-aligned, at avatar level
            HStack {
                Spacer()
                Button { navigateToEditProfile = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Edit Profile")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
                    .background(Color(hex: "#1E1E1E"))
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color(hex: "#3A3A3A"), lineWidth: 1))
                }
            }
            .padding(.top, 8)
        }
    }

    private var coverImageView: some View {
        ZStack(alignment: .trailing) {
            // Background gradient — replace with AsyncImage(url:) when coverImageURL is available
            LinearGradient(
                colors: [Color(hex: "#EAE0CC"), Color(hex: "#C8B48C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Placeholder illustration (SF Symbol composition)
            HStack(alignment: .bottom, spacing: -12) {
                Image(systemName: "person.fill")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(Color(hex: "#3C3580").opacity(0.65))
                    .offset(y: 16)

                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 76))
                    .foregroundStyle(gold.opacity(0.92))
                    .offset(y: -4)

                Image(systemName: "person.2.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(Color(hex: "#3C3580").opacity(0.55))
                    .offset(y: 18)
            }
            .padding(.trailing, 20)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var avatarView: some View {
        ZStack {
            Circle().fill(Color(hex: "#2A2A2A"))
            Image(systemName: "person.fill")
                .font(.system(size: 36))
                .foregroundStyle(gray)
        }
        .frame(width: 88, height: 88)
        .overlay(Circle().strokeBorder(gold, lineWidth: 3))
    }

    // MARK: - Profile Details
    private var profileDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let dm = viewModel.displayModel {
                Text(dm.username)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundStyle(gray)
                    Text(dm.dateOfBirth, format: .dateTime.month(.abbreviated).day().year())
                        .font(.system(size: 14))
                        .foregroundStyle(gray)
                }

                HStack(spacing: 8) {
                    Circle()
                        .fill(gray)
                        .frame(width: 5, height: 5)
                    Text(dm.email)
                        .font(.system(size: 14))
                        .foregroundStyle(gray)
                }
            } else {
                // Fallback to UserDefaults name while loading
                Text(UserDefaultsHelper.shared.string(key: .userName) ?? "Traveller")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
            }
        }
    }

    // MARK: - General Section
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("General")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            VStack(spacing: 0) {
                ForEach(Array(viewModel.generalItems.enumerated()), id: \.element.id) { index, item in
                    ProfileMenuRow(
                        icon: item.icon,
                        title: item.title,
                        subtitle: item.subtitle,
                        iconSurface: iconSurface,
                        gray: gray
                    ) {
                        if index == 0 { viewModel.openPersonalInfo() }
                        else          { viewModel.openSupport() }
                    }

                    if index < viewModel.generalItems.count - 1 {
                        Divider()
                            .background(Color(hex: "#2E2E2E"))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: - Others Section
    private var othersSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Others")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            VStack(spacing: 0) {
                SettingsToggleRow(
                    icon: "bell.fill",
                    title: "Push Notifications",
                    subtitle: "Alerts, updates, and news",
                    isOn: $viewModel.isNotificationsEnabled,
                    tint: gold,
                    iconSurface: iconSurface,
                    gray: gray
                )

                Divider()
                    .background(Color(hex: "#2E2E2E"))
                    .padding(.horizontal, 16)

                SettingsToggleRow(
                    icon: "faceid",
                    title: "Biometrics",
                    subtitle: "Use biometrics instead of your\nPIN on the lock screen",
                    isOn: $viewModel.isBiometricsEnabled,
                    tint: gold,
                    iconSurface: iconSurface,
                    gray: gray
                )
            }
            .background(surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: - Logout Button
    private var logoutButton: some View {
        Button { viewModel.logout() } label: {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(alertRed)
                Text("Log Out")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(alertRed)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(darkRed)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Version Footer
    private var versionFooter: some View {
        Text(viewModel.bottomVersionText)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color(hex: "#3A3A3A"))
            .tracking(1.5)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - ProfileMenuRow
// Navigation row: icon + title + subtitle + chevron
private struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconSurface: Color
    let gray: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconSurface)
                        .frame(width: 46, height: 46)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SettingsToggleRow
// Toggle row: icon + title + subtitle + native Toggle
private struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let tint: Color
    let iconSurface: Color
    let gray: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconSurface)
                    .frame(width: 46, height: 46)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(gray)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(tint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProfileView(appSession: AppSession())
        .environmentObject(AppSession())
}
