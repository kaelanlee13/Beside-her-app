//
//  Theme.swift
//  BesideHer
//
//  Central re-export of the most-used design tokens for ergonomic call sites.
//  Usage: Theme.accent, Theme.body, Theme.card, etc.
//

import SwiftUI

enum Theme {

    // ── Colors ─────────────────────────────────────────────────────────────────
    static let paper:           Color = .paper
    static let surface:         Color = .surface
    static let surfaceElevated: Color = .surfaceElevated
    static let paperTinted:     Color = .paperTinted
    static let ink:             Color = .ink
    static let inkSecondary:    Color = .inkSecondary
    static let divider:         Color = .divider
    static let accent:          Color = .accent
    static let accentSoft:      Color = .accentSoft
    static let sage:            Color = .sage
    static let clay:            Color = .clay
    static let alert:           Color = .alert
    static let onAccent:        Color = .onAccent

    // ── Typography ─────────────────────────────────────────────────────────────
    static let hero:         Font = .hero
    static let h1:           Font = .h1
    static let h2:           Font = .h2
    static let eyebrow:      Font = .eyebrow
    static let body:         Font = .bodyText
    static let caption:      Font = .captionText
    static let timerNumeral: Font = .timerNumeral

    // ── Corner Radius ──────────────────────────────────────────────────────────
    static let card:  CGFloat = Radius.card
    static let input: CGFloat = Radius.input
    static let pill:  CGFloat = Radius.pill

    // ── Spacing ────────────────────────────────────────────────────────────────
    static let xs:   CGFloat = Spacing.xs
    static let sm:   CGFloat = Spacing.sm
    static let md:   CGFloat = Spacing.md
    static let lg:   CGFloat = Spacing.lg
    static let xl:   CGFloat = Spacing.xl
    static let xxl:  CGFloat = Spacing.xxl
    static let xxxl: CGFloat = Spacing.xxxl
    static let huge: CGFloat = Spacing.huge
}
