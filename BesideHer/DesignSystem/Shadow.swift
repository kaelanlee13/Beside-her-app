//
//  Shadow.swift
//  BesideHer
//
//  Reusable shadow and border modifiers.
//

import SwiftUI

extension View {

    /// Subtle drop shadow used on all card surfaces.
    func premiumShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    /// 1pt hairline border in Color.divider, matched to Radius.card.
    func hairlineBorder(cornerRadius: CGFloat = Radius.card) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.divider, lineWidth: 1)
        )
    }
}
