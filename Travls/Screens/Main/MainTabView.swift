import SwiftUI

enum TravlsTab: CaseIterable {
    case home, cards, rewards, profile

    var label: String {
        switch self {
        case .home:    return "Home"
        case .cards:   return "Cards"
        case .rewards: return "Rewards"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home:    return "house.fill"
        case .cards:   return "creditcard.fill"
        case .rewards: return "trophy.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var selectedTab: TravlsTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label(TravlsTab.home.label,    systemImage: TravlsTab.home.icon) }
                .tag(TravlsTab.home)

            CardsPlaceholderView()
                .tabItem { Label(TravlsTab.cards.label,   systemImage: TravlsTab.cards.icon) }
                .tag(TravlsTab.cards)

            RewardsPlaceholderView()
                .tabItem { Label(TravlsTab.rewards.label, systemImage: TravlsTab.rewards.icon) }
                .tag(TravlsTab.rewards)

            ProfileView(appSession: appSession)
                .tabItem { Label(TravlsTab.profile.label, systemImage: TravlsTab.profile.icon) }
                .tag(TravlsTab.profile)
        }
        .tint(Color(hex: "#F2C94C"))
    }
}

private struct CardsPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Cards").foregroundStyle(.white).font(.title)
        }
    }
}

private struct RewardsPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Rewards").foregroundStyle(.white).font(.title)
        }
    }
}

#Preview { MainTabView().environmentObject(AppSession()) }
