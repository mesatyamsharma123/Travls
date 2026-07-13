import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel = BookingsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                statusPicker
                bookingsList
            }
            .background(TravlsTheme.Colors.background)
            .navigationTitle("My Trips")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await viewModel.loadBookings() }
    }

    private var statusPicker: some View {
        HStack(spacing: 0) {
            ForEach([BookingStatus.upcoming, .ongoing, .completed, .cancelled], id: \.self) { status in
                Button {
                    viewModel.selectedStatus = status
                } label: {
                    Text(status.rawValue.capitalized)
                        .font(.system(size: 13, weight: viewModel.selectedStatus == status ? .semibold : .regular))
                        .foregroundStyle(viewModel.selectedStatus == status ? TravlsTheme.Colors.primary : TravlsTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, TravlsTheme.Spacing.sm)
                        .overlay(alignment: .bottom) {
                            if viewModel.selectedStatus == status {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundStyle(TravlsTheme.Colors.primary)
                            }
                        }
                }
            }
        }
        .padding(.horizontal, TravlsTheme.Spacing.lg)
        .overlay(alignment: .bottom) { Divider() }
        .animation(.easeInOut(duration: 0.15), value: viewModel.selectedStatus)
    }

    @ViewBuilder
    private var bookingsList: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if viewModel.filteredBookings.isEmpty {
            EmptyStateView(
                icon: "suitcase",
                title: "No \(viewModel.selectedStatus.rawValue.capitalized) Trips",
                message: "Your \(viewModel.selectedStatus.rawValue) trips will appear here.",
                actionTitle: viewModel.selectedStatus == .upcoming ? "Explore Trips" : nil
            ) {}
        } else {
            List(viewModel.filteredBookings) { booking in
                BookingRow(booking: booking)
                    .listRowBackground(TravlsTheme.Colors.background)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(
                        top: TravlsTheme.Spacing.sm,
                        leading: TravlsTheme.Spacing.lg,
                        bottom: TravlsTheme.Spacing.sm,
                        trailing: TravlsTheme.Spacing.lg
                    ))
            }
            .listStyle(.plain)
            .refreshable { await viewModel.loadBookings() }
        }
    }
}

private struct BookingRow: View {
    let booking: Booking

    var body: some View {
        VStack(alignment: .leading, spacing: TravlsTheme.Spacing.sm) {
            AsyncImage(url: URL(string: booking.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                TravlsTheme.Colors.surface
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))

            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xs) {
                Text(booking.tripTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)
                Text(booking.destinationName)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)

                HStack {
                    Label("\(booking.passengerCount) traveller\(booking.passengerCount > 1 ? "s" : "")", systemImage: "person.2")
                        .font(.system(size: 12))
                        .foregroundStyle(TravlsTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(booking.currency) \(Int(booking.totalPrice))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(TravlsTheme.Colors.primary)
                }
            }
            .padding(.horizontal, TravlsTheme.Spacing.xs)
            .padding(.bottom, TravlsTheme.Spacing.sm)
        }
        .travlsCard()
    }
}

#Preview {
    BookingsView()
}
