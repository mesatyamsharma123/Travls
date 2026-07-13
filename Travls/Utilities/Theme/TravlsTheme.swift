import SwiftUI

enum TravlsTheme {

    enum Colors {
        static let primary        = Color(hex: "#1A6B8A")
        static let primaryLight   = Color(hex: "#2E9BBF")
        static let accent         = Color(hex: "#F4845F")
        static let success        = Color(hex: "#34C759")
        static let warning        = Color(hex: "#FF9F0A")
        static let error          = Color(hex: "#FF3B30")

        static let background     = Color(.systemBackground)
        static let surface        = Color(.secondarySystemBackground)
        static let surfaceElevated = Color(.tertiarySystemBackground)

        static let textPrimary    = Color(.label)
        static let textSecondary  = Color(.secondaryLabel)
        static let textTertiary   = Color(.tertiaryLabel)
        static let divider        = Color(.separator)
    }

    enum Spacing {
        static let xs:  CGFloat = 4
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum Radius {
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 12
        static let lg:  CGFloat = 16
        static let xl:  CGFloat = 24
        static let full: CGFloat = 999
    }

    enum Shadow {
        static let card = Shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        static let button = Shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
    }
}
