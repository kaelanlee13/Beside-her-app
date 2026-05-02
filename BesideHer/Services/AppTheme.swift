//
//  AppTheme.swift
//  BesideHer
//
//  Centralized theme constants for consistent styling
//

import SwiftUI

struct AppTheme {

    // MARK: - Colors

    /// Deep navy — hero card backgrounds, tab bar active tint
    static let deepNavy = Color(hex: "2C5282")

    /// Primary blue — buttons, links, progress fills
    static let primary = Color(hex: "3B7DD8")

    /// Soft blue — secondary accents, chips, subtle highlights
    static let softBlue = Color(hex: "7FB3E8")

    /// App page background — off-white, low-contrast base
    static let background = Color.paper

    /// Card surface — pure white on the page background
    static let card = Color.surface

    /// Near-black — primary body text
    static let textPrimary = Color(hex: "1A202C")

    /// Mid-gray — secondary / supporting text
    static let textSecondary = Color(hex: "5A6B80")

    /// Light gray — placeholder / disabled text
    static let textTertiary = Color(hex: "8E9BAD")

    /// Warm amber accent — badges, highlights, CTAs
    static let accent = Color(hex: "F6AD55")

    /// Subtle border / divider
    static let border = Color(hex: "E4EAF1")

    // MARK: - Legacy aliases (kept so existing call sites compile)
    static let primaryDark   = deepNavy
    static let primaryLight  = softBlue.opacity(0.2)
    static let accentLight   = accent.opacity(0.15)
    static let warning       = accent
    static let warningLight  = accent.opacity(0.15)

    // MARK: - Gradients

    /// Deep navy → primary blue — use for hero cards
    static let heroGradient = LinearGradient(
        colors: [deepNavy, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Primary blue → soft blue — use for progress bars, secondary cards
    static let primaryGradient = LinearGradient(
        colors: [primary, softBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Shadows

    static let cardShadow    = Color.black.opacity(0.06)
    static let primaryShadow = primary.opacity(0.20)

    // MARK: - Corner Radius

    static let cornerRadius:      CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusPill:  CGFloat = 24

    // MARK: - Typography

    /// Large serif headline — week number, hero titles (Georgia / New York)
    static func serifHero(size: CGFloat = 52) -> Font {
        Font.custom("Georgia", size: size).weight(.bold)
    }

    /// Medium serif headline — section titles, card headings
    static func serifTitle(size: CGFloat = 24) -> Font {
        Font.custom("Georgia", size: size).weight(.semibold)
    }

    /// Standard sans-serif body — readable prose
    static let bodyFont    = Font.system(size: 16, weight: .regular, design: .default)

    /// Small sans-serif caption
    static let captionFont = Font.system(size: 13, weight: .regular, design: .default)

    /// Bold sans-serif label — buttons, tab labels
    static let labelFont   = Font.system(size: 14, weight: .semibold, design: .default)
}
