//
//  AppTheme.swift
//  BesideHer
//
//  Legacy theme shim — kept only for typography helpers still referenced by
//  view code. Colors, gradients, radii, and shadows now live in the
//  Color/Radius/Shadow/Theme tokens.
//

import SwiftUI

struct AppTheme {

    // MARK: - Typography

    static func serifHero(size: CGFloat = 52) -> Font {
        Font.custom("Georgia", size: size).weight(.bold)
    }

    static func serifTitle(size: CGFloat = 24) -> Font {
        Font.custom("Georgia", size: size).weight(.semibold)
    }

    static let bodyFont    = Font.system(size: 16, weight: .regular, design: .default)
    static let captionFont = Font.system(size: 13, weight: .regular, design: .default)
    static let labelFont   = Font.system(size: 14, weight: .semibold, design: .default)
}
