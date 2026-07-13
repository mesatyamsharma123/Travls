import SwiftUI

struct PINKeypad: View {
    let onTap: (String) -> Void
    let onDelete: () -> Void

    private let rows = [["1","2","3"],["4","5","6"],["7","8","9"],["","0","⌫"]]
    private let surface = Color(hex: "#1C1C1C")

    var body: some View {
        VStack(spacing: 14) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { key in
                        if key.isEmpty {
                            Circle().fill(.clear).frame(width: 76, height: 76)
                        } else if key == "⌫" {
                            Button { onDelete() } label: {
                                Image(systemName: "delete.left")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(.white)
                                    .frame(width: 76, height: 76)
                                    .background(surface)
                                    .clipShape(Circle())
                            }
                        } else {
                            Button { onTap(key) } label: {
                                Text(key)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 76, height: 76)
                                    .background(surface)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
