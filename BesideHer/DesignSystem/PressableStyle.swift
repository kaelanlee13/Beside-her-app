//
//  PressableStyle.swift
//  BesideHer
//
//  Premium tap feel: subtle scale-down on press with a soft impact haptic.
//

import SwiftUI

struct PressableStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.98

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.8),
                       value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.5),
                             trigger: configuration.isPressed) { _, isPressed in isPressed }
    }
}

extension ButtonStyle where Self == PressableStyle {
    static var pressable: PressableStyle { PressableStyle() }
}
