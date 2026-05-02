//
//  Font+Theme.swift
//  BesideHer
//
//  Type scale for BesideHer v2.
//

import SwiftUI

// MARK: - Type scale

extension Font {

    /// New York Semibold 44 — week number, splash hero
    static let hero: Font = .system(size: 44, weight: .semibold, design: .serif)

    /// New York Semibold 32 — screen titles, section headers
    static let h1: Font = .system(size: 32, weight: .semibold, design: .serif)

    /// SF Pro Display Semibold 22 — card headings
    static let h2: Font = .system(size: 22, weight: .semibold, design: .default)

    /// SF Pro Rounded Semibold 12 — eyebrows / labels (see .eyebrowStyle() below)
    static let eyebrow: Font = .system(size: 12, weight: .semibold, design: .rounded)

    /// SF Pro Text Regular 17 — body copy
    /// Named `bodyText` to avoid collision with SwiftUI's built-in Font.body
    static let bodyText: Font = .system(size: 17, weight: .regular, design: .default)

    /// SF Pro Text Regular 13 — captions, supporting text
    /// Named `captionText` to avoid collision with SwiftUI's built-in Font.caption
    static let captionText: Font = .system(size: 13, weight: .regular, design: .default)

    /// Serif light 64, monospaced digits — contraction timer display
    static let timerNumeral: Font = .system(size: 64, weight: .light, design: .serif)
        .monospacedDigit()
}

// MARK: - Eyebrow ViewModifier

struct EyebrowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.eyebrow)
            .textCase(.uppercase)
            .tracking(1.4)
            .foregroundStyle(Color.inkSecondary)
    }
}

extension View {
    /// Applies the full eyebrow treatment: Rounded Semibold 12, uppercase, tracking 1.4, inkSecondary.
    func eyebrowStyle() -> some View {
        modifier(EyebrowStyle())
    }
}
