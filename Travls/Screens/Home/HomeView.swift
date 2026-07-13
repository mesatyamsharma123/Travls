import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xl) {
                    headerSection
                    featuredSection
                    trendingSection
                }
                .padding(.bottom, TravlsTheme.Spacing.xl)
            }
            .background(TravlsTheme.Colors.background)
            .refreshable { await viewModel.loadHome() }
            .navigationBarHidden(true)
        }
        .task { await viewModel.loadHome() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xs) {
            Text(greeting)
                .font(.system(size: 14))
                .foregroundStyle(TravlsTheme.Colors.textSecondary)

            Text("Where to next?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(TravlsTheme.Colors.textPrimary)
        }
        .padding(.horizontal, TravlsTheme.Spacing.lg)
        .padding(.top, TravlsTheme.Spacing.lg)
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: TravlsTheme.Spacing.md) {
            Text("Featured Destinations")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(TravlsTheme.Colors.textPrimary)
                .padding(.horizontal, TravlsTheme.Spacing.lg)

            if viewModel.isLoading {
                LoadingView().frame(height: 200)
            } else if viewModel.featuredDestinations.isEmpty {
                EmptyStateView(
                    icon: "map",
                    title: "No Destinations",
                    message: "Featured destinations will appear here."
                ).frame(height: 200)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TravlsTheme.Spacing.md) {
                        ForEach(viewModel.featuredDestinations) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                    .padding(.horizontal, TravlsTheme.Spacing.lg)
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: TravlsTheme.Spacing.md) {
            Text("Trending Trips")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(TravlsTheme.Colors.textPrimary)
                .padding(.horizontal, TravlsTheme.Spacing.lg)

            if viewModel.trendingTrips.isEmpty && !viewModel.isLoading {
                EmptyStateView(
                    icon: "flame",
                    title: "No Trending Trips",
                    message: "Check back soon for trending adventures."
                ).frame(height: 150)
            } else {
                VStack(spacing: TravlsTheme.Spacing.md) {
                    ForEach(viewModel.trendingTrips) { trip in
                        TripCard(trip: trip)
                            .padding(.horizontal, TravlsTheme.Spacing.lg)
                    }
                }
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default:      return "Good night"
        }
    }
}

private struct DestinationCard: View {
    let destination: Destination

    var body: some View {
        VStack(alignment: .leading, spacing: TravlsTheme.Spacing.sm) {
            AsyncImage(url: URL(string: destination.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                TravlsTheme.Colors.surface
            }
            .frame(width: 220, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))

            VStack(alignment: .leading, spacing: 2) {
                Text(destination.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)
                Text(destination.country)
                    .font(.system(size: 12))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
            }
        }
    }
}

private struct TripCard: View {
    let trip: Trip

    var body: some View {
        HStack(spacing: TravlsTheme.Spacing.md) {
            AsyncImage(url: URL(string: trip.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                TravlsTheme.Colors.surface
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.sm))

            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xs) {
                Text(trip.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)
                Text(trip.destinationName)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
                Text("\(trip.durationDays) days · \(trip.currency) \(Int(trip.price))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(TravlsTheme.Colors.primary)
            }

            Spacer()
        }
        .padding(TravlsTheme.Spacing.md)
        .travlsCard()
    }
}

#Preview {
    HomeView()
}
