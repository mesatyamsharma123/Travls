import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            TravlsTheme.Colors.primary
                .ignoresSafeArea()

            VStack(spacing: TravlsTheme.Spacing.md) {
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.white)

                Text("Travls")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Your world, explored.")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    SplashView()
}
