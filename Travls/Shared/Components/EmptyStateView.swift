import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: TravlsTheme.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(TravlsTheme.Colors.primary.opacity(0.4))

            VStack(spacing: TravlsTheme.Spacing.sm) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(TravlsTheme.Colors.textPrimary)

                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(TravlsTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(TravlsTheme.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "airplane",
        title: "No Trips Yet",
        message: "Start exploring destinations and book your first adventure.",
        actionTitle: "Explore Destinations"
    ) {}
}
