import SwiftUI

extension View {
    func travlsCard() -> some View {
        self
            .background(TravlsTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: TravlsTheme.Radius.lg))
            .shadow(
                color: TravlsTheme.Shadow.card.color,
                radius: TravlsTheme.Shadow.card.radius,
                x: TravlsTheme.Shadow.card.x,
                y: TravlsTheme.Shadow.card.y
            )
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }

    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}
