import SwiftUI

struct ConfirmPINView: View {
    @EnvironmentObject private var appSession: AppSession
    let originalPIN: String

    @State private var pin = ""
    @State private var shake = false
    @State private var errorMsg = ""

    private let gold = Color(hex: "#F2C94C")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        appSession.proceedToPINSetup()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Progress dots
                HStack(spacing: 8) {
                    Circle().fill(gold).frame(width: 8, height: 8)
                    Circle().fill(gold).frame(width: 8, height: 8)
                    Circle().fill(Color(hex: "#3A3A3A")).frame(width: 8, height: 8)
                }
                .padding(.top, 16)
                .padding(.bottom, 60)

                // Title
                VStack(spacing: 10) {
                    Text("Confirm your PIN")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Enter the same PIN again to confirm")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#6B6B6B"))
                }
                .padding(.bottom, 48)

                // PIN dots
                HStack(spacing: 18) {
                    ForEach(0..<6, id: \.self) { i in
                        Circle()
                            .fill(i < pin.count ? (errorMsg.isEmpty ? .white : Color(hex: "#FF453A")) : .clear)
                            .frame(width: 14, height: 14)
                            .overlay(Circle().strokeBorder((errorMsg.isEmpty ? .white : Color(hex: "#FF453A")).opacity(0.4), lineWidth: 1.5))
                    }
                }
                .offset(x: shake ? -10 : 0)
                .padding(.bottom, 12)

                if !errorMsg.isEmpty {
                    Text(errorMsg)
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: "#FF453A"))
                        .padding(.bottom, 24)
                } else {
                    Spacer().frame(height: 36)
                }

                // Numpad
                PINKeypad { key in
                    guard pin.count < 6 else { return }
                    pin += key
                    if pin.count == 6 {
                        if pin == originalPIN {
                            PINManager.shared.savePIN(pin)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                appSession.proceedToUnlockChoice()
                            }
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) { shake = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                shake = false
                                pin = ""
                                errorMsg = "PINs don't match. Try again."
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { errorMsg = "" }
                        }
                    }
                } onDelete: {
                    if !pin.isEmpty { pin.removeLast() }
                    errorMsg = ""
                }

                Spacer()
            }
        }
    }
}

#Preview { ConfirmPINView(originalPIN: "123456").environmentObject(AppSession()) }
