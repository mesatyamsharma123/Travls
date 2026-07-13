import SwiftUI

enum Tab: Int, CaseIterable {
    case home     = 0
    case explore  = 1
    case bookings = 2
    case profile  = 3

    var title: String {
        switch self {
        case .home:     return "Home"
        case .explore:  return "Explore"
        case .bookings: return "My Trips"
        case .profile:  return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home:     return "house"
        case .explore:  return "globe"
        case .bookings: return "suitcase"
        case .profile:  return "person"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:     return "house.fill"
        case .explore:  return "globe"
        case .bookings: return "suitcase.fill"
        case .profile:  return "person.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem { Label(Tab.home.title, systemImage: Tab.home.icon) }

            ExploreView()
                .tag(Tab.explore)
                .tabItem { Label(Tab.explore.title, systemImage: Tab.explore.icon) }

            BookingsView()
                .tag(Tab.bookings)
                .tabItem { Label(Tab.bookings.title, systemImage: Tab.bookings.icon) }

            ProfileView(appSession: appSession)
                .tag(Tab.profile)
                .tabItem { Label(Tab.profile.title, systemImage: Tab.profile.icon) }
        }
        .tint(TravlsTheme.Colors.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppSession())
}
