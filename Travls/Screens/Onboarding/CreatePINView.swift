import SwiftUI

struct CreatePINView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var pin = ""

    private let gold = Color(hex: "#F2C94C")
    private let surface = Color(hex: "#1C1C1C")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Spacer()
                    Button("Skip") {
                        appSession.proceedToUnlockChoice()
                    }
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "#6B6B6B"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Progress dots
                HStack(spacing: 8) {
                    Circle().fill(gold).frame(width: 8, height: 8)
                    Circle().fill(Color(hex: "#3A3A3A")).frame(width: 8, height: 8)
                    Circle().fill(Color(hex: "#3A3A3A")).frame(width: 8, height: 8)
                }
                .padding(.top, 16)
                .padding(.bottom, 60)

                // Title
                VStack(spacing: 10) {
                    Text("Create a PIN")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Choose a 6-digit PIN to secure your account")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#6B6B6B"))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 48)

                // PIN dots
                HStack(spacing: 18) {
                    ForEach(0..<6, id: \.self) { i in
                        Circle()
                            .fill(i < pin.count ? .white : .clear)
                            .frame(width: 14, height: 14)
                            .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1.5))
                    }
                }
                .padding(.bottom, 48)

                // Numpad
                PINKeypad { key in
                    if pin.count < 6 { pin += key }
                    if pin.count == 6 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            appSession.proceedToConfirmPIN(pin)
                        }
                    }
                } onDelete: {
                    if !pin.isEmpty { pin.removeLast() }
                }

                Spacer()
            }
        }
    }
}

#Preview { CreatePINView().environmentObject(AppSession()) }
