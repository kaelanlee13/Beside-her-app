//
//  EditorialCard.swift
//  BesideHer
//

import SwiftUI

struct EditorialCard: View {
    let eyebrow: String
    let headline: String
    let caption: String
    let illustrationName: String
    let tintColor: Color
    let action: () -> Void

    @State private var hapticTrigger = false

    var body: some View {
        Button(action: {
            hapticTrigger.toggle()
            action()
        }) {
            ZStack(alignment: .bottomLeading) {
                // Tinted surface background
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.surface)
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(tintColor.opacity(0.18))

                // Illustration — top-right
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: illustrationName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .foregroundStyle(tintColor.opacity(0.55))
                            .padding(.top, Spacing.xl)
                            .padding(.trailing, Spacing.xl)
                    }
                    Spacer()
                }

                // Text block — bottom-left
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(eyebrow)
                        .eyebrowStyle()

                    Text(headline)
                        .font(.h2)
                        .foregroundStyle(Color.ink)
                        .lineLimit(2)

                    Text(caption)
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                        .lineLimit(2)
                }
                .padding(Spacing.xl)
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .premiumShadow()
        }
        .buttonStyle(ScalePressStyle())
        .sensoryFeedback(.impact(weight: .light), trigger: hapticTrigger)
    }
}

// Subtle scale-down on press, spring back on release.
private struct ScalePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        EditorialCard(
            eyebrow: "14 ARTICLES",
            headline: "Emotional Support",
            caption: "Being there for every moment that matters",
            illustrationName: "heart.fill",
            tintColor: Color.accent,
            action: {}
        )
        EditorialCard(
            eyebrow: "11 ARTICLES",
            headline: "Financial Prep",
            caption: "Plan ahead so you can be present",
            illustrationName: "dollarsign.circle.fill",
            tintColor: Color.sage,
            action: {}
        )
    }
    .padding(Spacing.xl)
    .background(Color.paper)
}
