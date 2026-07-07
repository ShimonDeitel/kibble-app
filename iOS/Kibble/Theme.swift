import SwiftUI

/// Unique visual identity for Kibble.
enum Theme {
    static let background = Color(red: 0.180, green: 0.125, blue: 0.075)
    static let accent = Color(red: 0.949, green: 0.651, blue: 0.353)
    static let secondary = Color(red: 0.847, green: 0.765, blue: 0.647)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
