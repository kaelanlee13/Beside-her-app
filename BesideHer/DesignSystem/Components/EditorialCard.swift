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
    let backgroundTint: Color
    let iconTint: Color
    let action: () -> Void

    @State private var hapticTrigger = false

    var body: some View {
        Button(action: {
            hapticTrigger.toggle()
            action()
        }) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.surface)
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(backgroundTint)

                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: illustrationName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundStyle(iconTint)
                            .padding(.top, Spacing.lg)
                            .padding(.trailing, Spacing.lg)
                    }
                    Spacer()
                }

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
                .padding(Spacing.lg)
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .premiumShadow()
        }
        .buttonStyle(.pressable)
        .sensoryFeedback(.impact(weight: .light), trigger: hapticTrigger)
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        EditorialCard(
            eyebrow: "14 ARTICLES",
            headline: "Emotional Support",
            caption: "Being there for every moment that matters",
            illustrationName: "heart.fill",
            backgroundTint: Color.accent.opacity(0.18),
            iconTint: Color.accent.opacity(0.7),
            action: {}
        )
        EditorialCard(
            eyebrow: "11 ARTICLES",
            headline: "Financial Prep",
            caption: "Plan ahead so you can be present",
            illustrationName: "dollarsign.circle.fill",
            backgroundTint: Color.sage.opacity(0.18),
            iconTint: Color.sage.opacity(0.85),
            action: {}
        )
    }
    .padding(Spacing.lg)
    .background(Color.paper)
}
