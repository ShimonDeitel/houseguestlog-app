import SwiftUI

enum Theme {
    static let background = Color(hex: "#150E1E")
    static let card = Color(hex: "#241733")
    static let accent = Color(hex: "#6A4C93")
    static let accentDeep = Color(hex: "#2E1A47")
    static let textPrimary = Color(hex: "#F2ECFB")
    static let textSecondary = Color(hex: "#F2ECFB").opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
