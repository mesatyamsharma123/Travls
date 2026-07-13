import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appSession: AppSession

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var taglineOpacity: Double = 0

    private let gold = Color(hex: "#F2C94C")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(gold.opacity(0.12))
                        .frame(width: 110, height: 110)

                    Circle()
                        .strokeBorder(gold.opacity(0.25), lineWidth: 1)
                        .frame(width: 110, height: 110)

                    Image(systemName: "airplane.departure")
                        .font(.system(size: 46, weight: .semibold))
                        .foregroundStyle(gold)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: 8) {
                    Text("Travls")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Explore the world")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color(hex: "#6B6B6B"))
                        .tracking(1)
                }
                .opacity(titleOpacity)
            }

            VStack {
                Spacer()
                HStack(spacing: 6) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i == 1 ? gold : gold.opacity(0.3))
                            .frame(width: i == 1 ? 8 : 5, height: i == 1 ? 8 : 5)
                    }
                }
                .opacity(taglineOpacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72).delay(0.1)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.45)) {
                titleOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.7)) {
                taglineOpacity = 1.0
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_400_000_000)
            withAnimation(.easeInOut(duration: 0.35)) {
                appSession.completeSplash()
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppSession())
}
