import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isDisabled ? TravlsTheme.Colors.primary.opacity(0.5) : TravlsTheme.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.md))
            .shadow(
                color: TravlsTheme.Shadow.button.color,
                radius: TravlsTheme.Shadow.button.radius,
                x: TravlsTheme.Shadow.button.x,
                y: TravlsTheme.Shadow.button.y
            )
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Explore Now") {}
        PrimaryButton(title: "Loading...", isLoading: true) {}
        PrimaryButton(title: "Disabled", isDisabled: true) {}
    }
    .padding()
}
