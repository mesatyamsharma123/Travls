import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: ProfileViewModel

    private let gold    = Color(hex: "#F2C94C")
    private let surface = Color(hex: "#1A1A1A")
    private let gray    = Color(hex: "#6B6B6B")

    init(appSession: AppSession) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(appSession: appSession))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    profileHeader
                    statsCard
                    settingsCard
                    logoutButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .task { await viewModel.loadProfile() }
    }

    // MARK: Header
    private var profileHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#2A2A2A"))
                    .frame(width: 64, height: 64)
                Image(systemName: "person.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.profile?.name ?? UserDefaultsHelper.shared.string(key: .userName) ?? "Traveller")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                if let profile = viewModel.profile {
                    Text(profile.phone)
                        .font(.system(size: 13))
                        .foregroundStyle(gray)
                } else {
                    Text("Travls Member")
                        .font(.system(size: 13))
                        .foregroundStyle(gray)
                }
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(surface)
                    .frame(width: 40, height: 40)
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(gold)
            }
        }
        .padding(16)
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: Stats
    private var statsCard: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(viewModel.profile?.totalTrips ?? 0)", label: "Trips", gold: gold, gray: gray)
            divider
            StatItem(value: "\(viewModel.profile?.countriesVisited ?? 0)", label: "Countries", gold: gold, gray: gray)
            divider
            StatItem(value: "0", label: "Reviews", gold: gold, gray: gray)
        }
        .padding(.vertical, 20)
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(hex: "#2A2A2A"))
            .frame(width: 1, height: 36)
    }

    // MARK: Settings
    private var settingsCard: some View {
        VStack(spacing: 0) {
            ProfileRow(icon: "bell", title: "Notifications", gold: gold, gray: gray)
            rowDivider
            ProfileRow(icon: "lock.shield", title: "Privacy & Security", gold: gold, gray: gray)
            rowDivider
            ProfileRow(icon: "questionmark.circle", title: "Help & Support", gold: gold, gray: gray)
            rowDivider
            ProfileRow(icon: "info.circle", title: "About Travls", gold: gold, gray: gray)
        }
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(Color(hex: "#2A2A2A"))
            .frame(height: 1)
            .padding(.leading, 56)
    }

    // MARK: Logout
    private var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                Text("Log Out")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

private struct StatItem: View {
    let value: String
    let label: String
    let gold: Color
    let gray: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(gold)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(gray)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileRow: View {
    let icon: String
    let title: String
    let gold: Color
    let gray: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#2A2A2A"))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(gold)
            }
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView(appSession: AppSession())
        .environmentObject(AppSession())
}
