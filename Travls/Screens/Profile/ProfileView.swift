import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: ProfileViewModel

    init(appSession: AppSession) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(appSession: appSession))
    }

    var body: some View {
        NavigationStack {
            List {
                profileHeader
                statsSection
                settingsSection
                logoutSection
            }
            .listStyle(.insetGrouped)
            .background(TravlsTheme.Colors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await viewModel.loadProfile() }
    }

    private var profileHeader: some View {
        Section {
            HStack(spacing: TravlsTheme.Spacing.md) {
                Circle()
                    .fill(TravlsTheme.Colors.primary.opacity(0.15))
                    .frame(width: 64, height: 64)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(TravlsTheme.Colors.primary)
                    }

                VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xs) {
                    Text(viewModel.profile?.name ?? UserDefaultsHelper.shared.string(key: .userName) ?? "Traveller")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(TravlsTheme.Colors.textPrimary)

                    if let profile = viewModel.profile {
                        Text(profile.phone)
                            .font(.system(size: 14))
                            .foregroundStyle(TravlsTheme.Colors.textSecondary)
                    }
                }
            }
            .padding(.vertical, TravlsTheme.Spacing.sm)
        }
    }

    private var statsSection: some View {
        Section("Your Journey") {
            HStack {
                StatItem(value: "\(viewModel.profile?.totalTrips ?? 0)", label: "Trips")
                Divider()
                StatItem(value: "\(viewModel.profile?.countriesVisited ?? 0)", label: "Countries")
                Divider()
                StatItem(value: "0", label: "Reviews")
            }
            .frame(height: 60)
        }
    }

    private var settingsSection: some View {
        Section("Settings") {
            ProfileRow(icon: "bell", title: "Notifications")
            ProfileRow(icon: "lock.shield", title: "Privacy & Security")
            ProfileRow(icon: "questionmark.circle", title: "Help & Support")
            ProfileRow(icon: "info.circle", title: "About Travls")
        }
    }

    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.logout()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Log Out")
                }
            }
        }
    }
}

private struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(TravlsTheme.Colors.textPrimary)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(TravlsTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileRow: View {
    let icon: String
    let title: String

    var body: some View {
        Label(title, systemImage: icon)
            .foregroundStyle(TravlsTheme.Colors.textPrimary)
    }
}

#Preview {
    ProfileView(appSession: AppSession())
        .environmentObject(AppSession())
}
