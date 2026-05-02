//
//  Color+Theme.swift
//  BesideHer
//
//  Adaptive color tokens — Palette A (Linen & Ink) in light, Palette C (Midnight Editorial) in dark.
//  Uses UIColor(dynamicProvider:) so tokens resolve at the UIKit trait level, not SwiftUI render time.
//

import SwiftUI
import UIKit

// MARK: - Hex initializers

extension Color {

    /// Create a Color from a 0xRRGGBB integer literal.
    init(hex: UInt, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8)  & 0xFF) / 255.0
        let b = Double( hex        & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    /// Create a Color that automatically switches between light and dark hex values
    /// based on the current UIKit trait collection. Works in all contexts.
    init(light: UInt, dark: UInt, opacity: Double = 1.0) {
        let uiColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: dark,  opacity: opacity)
                : UIColor(hex: light, opacity: opacity)
        }
        self.init(uiColor)
    }
}

// MARK: - UIColor hex helper (private)

private extension UIColor {
    convenience init(hex: UInt, opacity: Double = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8)  & 0xFF) / 255.0
        let b = CGFloat( hex        & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(opacity))
    }
}

// MARK: - Adaptive design tokens

extension Color {

    // ── Surfaces & Text ────────────────────────────────────────────────────────

    /// Global page background  (light: #F6F1E8 / dark: #14110E)
    static let paper           = Color(light: 0xF6F1E8, dark: 0x14110E)

    /// Card surface            (light: #FBF8F2 / dark: #1E1A16)
    static let surface         = Color(light: 0xFBF8F2, dark: 0x1E1A16)

    /// Elevated card / hero    (light: #FBF8F2 / dark: #272320)
    static let surfaceElevated = Color(light: 0xFBF8F2, dark: 0x272320)

    /// Hero card tinted block  (light: #F1E5D6 / dark: #272320)
    static let paperTinted     = Color(light: 0xF1E5D6, dark: 0x272320)

    /// Primary text            (light: #1F1B16 / dark: #F2EDE3)
    static let ink             = Color(light: 0x1F1B16, dark: 0xF2EDE3)

    /// Secondary / caption text (light: #6B6258 / dark: #A39C90)
    static let inkSecondary    = Color(light: 0x6B6258, dark: 0xA39C90)

    /// Hairlines & dividers    (light: #E7DFD2 / dark: #2E2925)
    static let divider         = Color(light: 0xE7DFD2, dark: 0x2E2925)

    // ── Accent ─────────────────────────────────────────────────────────────────

    /// Terracotta (light) / Warm amber (dark)  (#B5572E / #E8B57E)
    static let accent          = Color(light: 0xB5572E, dark: 0xE8B57E)

    /// 18 % tinted accent background
    static let accentSoft      = Color(light: 0xB5572E, dark: 0xE8B57E, opacity: 0.18)

    // ── Status ─────────────────────────────────────────────────────────────────

    /// Success / sage green    (#7A8B6F / #9DB39A)
    static let sage            = Color(light: 0x7A8B6F, dark: 0x9DB39A)

    /// Warm secondary / clay   (#C9A689 / #C9A689)
    static let clay            = Color(light: 0xC9A689, dark: 0xC9A689)

    /// Error / contraction-active state  (#A8412B / #D86A4A)
    static let alert           = Color(light: 0xA8412B, dark: 0xD86A4A)

    // ── On-accent ──────────────────────────────────────────────────────────────

    /// Text / icons that sit on top of a filled accent surface
    static let onAccent        = Color(light: 0xF6F1E8, dark: 0x14110E)
}

// MARK: - Previews

#Preview("Light mode swatches") {
    SwatchGrid()
        .preferredColorScheme(.light)
}

#Preview("Dark mode swatches") {
    SwatchGrid()
        .preferredColorScheme(.dark)
}

private struct SwatchGrid: View {
    private let tokens: [(name: String, color: Color)] = [
        ("paper",           .paper),
        ("surface",         .surface),
        ("surfaceElevated", .surfaceElevated),
        ("paperTinted",     .paperTinted),
        ("ink",             .ink),
        ("inkSecondary",    .inkSecondary),
        ("divider",         .divider),
        ("accent",          .accent),
        ("accentSoft",      .accentSoft),
        ("sage",            .sage),
        ("clay",            .clay),
        ("alert",           .alert),
        ("onAccent",        .onAccent),
    ]

    var body: some View {
        ZStack {
            Color.paper.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(tokens, id: \.name) { token in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(token.color)
                                .frame(width: 60, height: 32)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.divider, lineWidth: 0.5)
                                )
                            Text(token.name)
                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                .foregroundStyle(Color.ink)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
}
