import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: TravlsTheme.Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(TravlsTheme.Colors.primary)
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(TravlsTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TravlsTheme.Colors.background)
    }
}

#Preview {
    LoadingView()
}
