//
//  Shadow.swift
//  BesideHer
//
//  Reusable shadow and border modifiers.
//

import SwiftUI

extension View {

    /// Premium card elevation that works in both light and dark mode.
    /// In light mode, a soft black shadow lifts the card.
    /// In dark mode, a 1pt warm-divider border defines the card edge.
    /// Both modes get both effects — the shadow is invisible in dark
    /// (4% black on warm-black) and the border is barely visible in light
    /// (warm divider on cream), so they coexist without fighting.
    func premiumShadow(cornerRadius: CGFloat = Radius.card) -> some View {
        self
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.divider, lineWidth: 1)
            )
    }

    /// 1pt hairline border in Color.divider — use when you want the border without a shadow.
    func hairlineBorder(cornerRadius: CGFloat = Radius.card) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.divider, lineWidth: 1)
        )
    }
}
