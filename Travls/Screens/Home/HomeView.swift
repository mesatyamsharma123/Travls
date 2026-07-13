import SwiftUI

struct HomeView: View {
    private let gold     = Color(hex: "#F2C94C")
    private let surface  = Color(hex: "#1A1A1A")
    private let textGray = Color(hex: "#6B6B6B")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerRow
                    walletCard
                    quickActions
                    promoCard
                    smartTipsSection
                    firstCardSection
                    firstDepositSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: Header
    private var headerRow: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: "#2A2A2A"))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(textGray)
                    )
                Circle().fill(Color(hex: "#34C759")).frame(width: 10, height: 10)
                    .offset(x: 1, y: 1)
            }

            HStack(spacing: 4) {
                Text(UserDefaultsHelper.shared.string(key: .userName) ?? "Traveller")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(gold)
            }

            Spacer()

            HStack(spacing: 10) {
                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12, weight: .semibold))
                        Text("RESTART")
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.5)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(gold)
                    .clipShape(Capsule())
                }

                Button {} label: {
                    Image(systemName: "bell")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(Color(hex: "#1A1A1A"))
                        .clipShape(Circle())
                }
            }
        }
    }

    // MARK: Wallet Card
    private var walletCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(gold)
                    .frame(width: 56, height: 56)
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.black)
            }
            Text("Set up your wallet")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("Takes less than a minute")
                .font(.system(size: 13))
                .foregroundStyle(textGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }

    // MARK: Quick Actions
    private var quickActions: some View {
        HStack(spacing: 12) {
            QuickActionItem(icon: "plus",                    label: "DEPOSIT",  isGold: true)
            QuickActionItem(icon: "arrow.up",                label: "WITHDRAW")
            QuickActionItem(icon: "arrow.left.arrow.right",  label: "ACTIVITY")
            QuickActionItem(icon: "creditcard",              label: "CARDS")
        }
    }

    // MARK: Promo Card
    private var promoCard: some View {
        ZStack(alignment: .trailing) {
            VStack(alignment: .leading, spacing: 8) {
                Text("COMING SOON")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(gold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#2A2000"))
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(gold.opacity(0.4), lineWidth: 1))

                HStack(spacing: 0) {
                    Text("NEW ")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(gold)
                    Text("Earn airline miles\non every swipe")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }
                .lineSpacing(2)

                Text("On travel and card payments")
                    .font(.system(size: 13))
                    .foregroundStyle(textGray)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "bitcoinsign.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(gold.opacity(0.85))
                .padding(.trailing, 16)
        }
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: Smart Tips
    private var smartTipsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("SMART TIPS")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    SmartTipCard(
                        icon: "shield.fill",
                        title: "Stable Value",
                        subtitle: "Protect your funds from market volatility with stable assets."
                    )
                    SmartTipCard(
                        icon: "creditcard.fill",
                        title: "Spend Anywhere",
                        subtitle: "Use your card wherever it's accepted for secure payments."
                    )
                    SmartTipCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Track Spending",
                        subtitle: "Monitor your transactions and save smarter every day."
                    )
                    SmartTipCard(
                        icon: "airplane",
                        title: "Earn Miles",
                        subtitle: "Book flights and earn reward miles on every purchase."
                    )
                }
                .padding(.horizontal, 1)
            }
        }
    }

    // MARK: Get Your First Card
    private var firstCardSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Watermark
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 100))
                .foregroundStyle(Color.white.opacity(0.04))
                .offset(x: -10, y: 10)

            VStack(alignment: .leading, spacing: 16) {
                // Title row
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Get Your First Card")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)

                        Text("GET STARTED")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(0.8)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#2A2A2A"))
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(.white.opacity(0.3), lineWidth: 1))
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color(hex: "#2A2A2A"))
                            .frame(width: 48, height: 48)
                        Text("0%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }

                Text("Verify your identity to unlock all features.")
                    .font(.system(size: 14))
                    .foregroundStyle(textGray)

                // Progress steps
                HStack(spacing: 0) {
                    // Step 1 – Verify (active)
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .strokeBorder(gold, lineWidth: 2)
                                .frame(width: 36, height: 36)
                            Circle()
                                .fill(gold)
                                .frame(width: 12, height: 12)
                        }
                        Text("Verify")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(gold)
                    }

                    // Connector
                    Rectangle()
                        .fill(Color(hex: "#3A3A3A"))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)

                    // Step 2 – Get Card (locked)
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color(hex: "#3A3A3A"), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                .frame(width: 36, height: 36)
                            Image(systemName: "lock.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#3A3A3A"))
                        }
                        Text("Get Card")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(textGray)
                    }

                    // Connector
                    Rectangle()
                        .fill(Color(hex: "#3A3A3A"))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)

                    // Step 3 – Spend (locked)
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color(hex: "#3A3A3A"), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                .frame(width: 36, height: 36)
                            Image(systemName: "lock.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#3A3A3A"))
                        }
                        Text("Spend")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(textGray)
                    }
                }

                // CTA
                HStack {
                    Spacer()
                    Button {} label: {
                        HStack(spacing: 8) {
                            Text("Choose Card")
                                .font(.system(size: 15, weight: .semibold))
                            Image(systemName: "creditcard")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }

    // MARK: Make Your First Deposit
    private var firstDepositSection: some View {
        HStack(spacing: 16) {
            // Clock illustration
            ZStack {
                Text("⏰")
                    .font(.system(size: 64))
                // Lightning bolts
                Image(systemName: "bolt.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(gold)
                    .offset(x: -34, y: -10)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(gold)
                    .offset(x: 34, y: -20)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(gold)
                    .offset(x: 30, y: 16)
            }
            .frame(width: 100)

            VStack(alignment: .leading, spacing: 10) {
                Text("Make your first deposit")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text("Fund your account with crypto and you're ready to spend.")
                    .font(.system(size: 13))
                    .foregroundStyle(textGray)
                    .fixedSize(horizontal: false, vertical: true)

                Button {} label: {
                    HStack(spacing: 8) {
                        Text("Deposit")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "wallet.bifold")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.white)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct QuickActionItem: View {
    let icon: String
    let label: String
    var isGold: Bool = false
    private let gold = Color(hex: "#F2C94C")

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isGold ? gold : Color(hex: "#1A1A1A"))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isGold ? .black : .white)
            }
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color(hex: "#6B6B6B"))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SmartTipCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#2A2A2A"))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color(hex: "#8A8A8A"))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "#6B6B6B"))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .frame(width: 200, height: 180)
        .background(Color(hex: "#1A1A1A"))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview { HomeView() }
