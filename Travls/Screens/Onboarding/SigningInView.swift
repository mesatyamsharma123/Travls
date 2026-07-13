import SwiftUI

struct SigningInView: View {
    @State private var pulse = false
    private let gold = Color(hex: "#C9A227")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 28) {
                // Logo with pulsing rings
                ZStack {
                    Circle().fill(gold.opacity(0.06)).frame(width: 180, height: 180).scaleEffect(pulse ? 1.15 : 1.0)
                    Circle().fill(gold.opacity(0.10)).frame(width: 140, height: 140).scaleEffect(pulse ? 1.1 : 1.0)
                    Circle().fill(gold.opacity(0.18)).frame(width: 100, height: 100)
                    Circle().fill(gold).frame(width: 68, height: 68)
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.black)
                }
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)

                VStack(spacing: 10) {
                    Text("Signing you in...")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Securely verifying your account.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#6B6B6B"))
                }

                ProgressView()
                    .tint(gold)
                    .scaleEffect(1.2)
            }
        }
        .onAppear { pulse = true }
    }
}

#Preview { SigningInView() }
