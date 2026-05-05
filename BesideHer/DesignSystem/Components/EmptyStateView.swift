//
//  EmptyStateView.swift
//  BesideHer
//
//  Quiet, editorial empty state. Use anywhere a screen would otherwise show
//  nothing, or in place of SwiftUI's default ContentUnavailableView.
//

import SwiftUI

struct EmptyStateView: View {
    let illustrationName: String
    let headline: String
    let caption: String?
    let tintColor: Color

    init(
        illustrationName: String,
        headline: String,
        caption: String? = nil,
        tintColor: Color = .accent
    ) {
        self.illustrationName = illustrationName
        self.headline = headline
        self.caption = caption
        self.tintColor = tintColor
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: illustrationName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(tintColor.opacity(0.7))
                .padding(.bottom, Spacing.xs)

            Text(headline)
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .foregroundStyle(Color.ink)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            if let caption {
                Text(caption)
                    .font(.bodyText)
                    .foregroundStyle(Color.inkSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.xxxl)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Trimester complete") {
    EmptyStateView(
        illustrationName: "checkmark.seal",
        headline: "You're ahead of the curve.",
        caption: "Nothing left this trimester."
    )
    .background(Color.paper)
}

#Preview("Pick where to start") {
    EmptyStateView(
        illustrationName: "book.closed",
        headline: "Pick where to start.",
        caption: "Articles are short and dad-tested.",
        tintColor: Color.sage
    )
    .background(Color.paper)
}

#Preview("Quiet week") {
    EmptyStateView(
        illustrationName: "leaf",
        headline: "A quiet week.",
        caption: "Rest, hydrate, and check in with her.",
        tintColor: Color.clay
    )
    .background(Color.paper)
}
