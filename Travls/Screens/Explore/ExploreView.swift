import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                categoryPicker
                resultsList
            }
            .background(TravlsTheme.Colors.background)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var searchBar: some View {
        HStack(spacing: TravlsTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(TravlsTheme.Colors.textSecondary)

            TextField("Search destinations, trips...", text: $viewModel.filter.query)
                .font(.system(size: 15))
                .onChange(of: viewModel.filter.query) { _, _ in
                    viewModel.onSearchChanged()
                }

            if !viewModel.filter.query.isEmpty {
                Button { viewModel.filter.query = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(TravlsTheme.Colors.textSecondary)
                }
            }
        }
        .padding(TravlsTheme.Spacing.md)
        .background(TravlsTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.full))
        .padding(.horizontal, TravlsTheme.Spacing.lg)
        .padding(.vertical, TravlsTheme.Spacing.md)
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: TravlsTheme.Spacing.sm) {
                ForEach(TripCategory.allCases) { category in
                    CategoryChip(
                        category: category,
                        isSelected: viewModel.filter.category == category
                    ) {
                        viewModel.filter.category = viewModel.filter.category == category ? nil : category
                        Task { await viewModel.search() }
                    }
                }
            }
            .padding(.horizontal, TravlsTheme.Spacing.lg)
        }
        .padding(.bottom, TravlsTheme.Spacing.sm)
    }

    @ViewBuilder
    private var resultsList: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if viewModel.results.isEmpty && !viewModel.filter.isEmpty {
            EmptyStateView(
                icon: "magnifyingglass",
                title: "No Results",
                message: "Try a different search term or category."
            )
        } else if viewModel.filter.isEmpty {
            EmptyStateView(
                icon: "globe.asia.australia",
                title: "Discover the World",
                message: "Search for destinations, cities, or trip types."
            )
        } else {
            List(viewModel.results) { result in
                SearchResultRow(result: result)
                    .listRowBackground(TravlsTheme.Colors.background)
                    .listRowInsets(EdgeInsets(
                        top: TravlsTheme.Spacing.sm,
                        leading: TravlsTheme.Spacing.lg,
                        bottom: TravlsTheme.Spacing.sm,
                        trailing: TravlsTheme.Spacing.lg
                    ))
            }
            .listStyle(.plain)
        }
    }
}

private struct CategoryChip: View {
    let category: TripCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: TravlsTheme.Spacing.xs) {
                Image(systemName: category.icon)
                    .font(.system(size: 13))
                Text(category.rawValue)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, TravlsTheme.Spacing.md)
            .padding(.vertical, TravlsTheme.Spacing.sm)
            .background(isSelected ? TravlsTheme.Colors.primary : TravlsTheme.Colors.surface)
            .foregroundStyle(isSelected ? .white : TravlsTheme.Colors.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.full))
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

private struct SearchResultRow: View {
    let result: SearchResult

    var body: some View {
        HStack(spacing: TravlsTheme.Spacing.md) {
            AsyncImage(url: URL(string: result.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                TravlsTheme.Colors.surface
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.sm))

            VStack(alignment: .leading, spacing: TravlsTheme.Spacing.xs) {
                Text(result.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)
                Text(result.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
                if let price = result.price, let currency = result.currency {
                    Text("From \(currency) \(Int(price))")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(TravlsTheme.Colors.primary)
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
