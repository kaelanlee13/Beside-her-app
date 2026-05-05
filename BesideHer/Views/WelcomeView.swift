//
//  WelcomeView.swift
//  BesideHer
//
//  Onboarding intro: 3 quiet, paginated screens with parallax illustrations.
//

import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void

    @State private var scrollID: Int? = 0

    private struct Page {
        let illustration: String
        let headline: String
        let caption: String
    }

    private let pages: [Page] = [
        Page(
            illustration: "figure.2.and.child.holdinghands",
            headline: "You're not on the sidelines.",
            caption: "Pregnancy is a team sport. This app helps you show up for her, every week."
        ),
        Page(
            illustration: "calendar",
            headline: "Forty weeks. One companion.",
            caption: "What's happening, what to do, and what to say — without the noise."
        ),
        Page(
            illustration: "heart.text.square",
            headline: "Built by dads, for dads.",
            caption: "Practical, calm, and honest. No jargon, no judgment."
        ),
    ]

    private var currentPage: Int { scrollID ?? 0 }
    private var isLastPage: Bool { currentPage == pages.count - 1 }
    private var buttonTitle: String { isLastPage ? "Get started" : "Continue" }

    var body: some View {
        ZStack {
            Color.paper.ignoresSafeArea()

            VStack(spacing: 0) {

                // ─── Paginated illustrations + copy ──────────────────────────
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(pages.indices, id: \.self) { index in
                            pageView(index: index)
                                .containerRelativeFrame(.horizontal)
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollID)
                .scrollIndicators(.hidden)
                .coordinateSpace(name: "welcomeScroll")
                .sensoryFeedback(.selection, trigger: currentPage)

                // ─── Page dots ───────────────────────────────────────────────
                pageDots
                    .padding(.top, Spacing.lg)
                    .padding(.bottom, Spacing.xl)

                // ─── Primary action ──────────────────────────────────────────
                Button(action: advance) {
                    Text(buttonTitle)
                        .font(.bodyText.weight(.semibold))
                        .foregroundStyle(Color.paper)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Capsule().fill(Color.ink))
                        .contentTransition(.opacity)
                }
                .buttonStyle(.pressable)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.lg)
            }
        }
    }

    // MARK: - Page

    @ViewBuilder
    private func pageView(index: Int) -> some View {
        let page = pages[index]

        VStack(spacing: 0) {

            // Top half — illustration with 0.6x parallax
            GeometryReader { geo in
                // Page width equals container width (containerRelativeFrame).
                // midX in scroll-space is containerWidth/2 when the page is centered.
                let pageMidX  = geo.frame(in: .named("welcomeScroll")).midX
                let centerRef = geo.size.width / 2
                let parallax  = (centerRef - pageMidX) * 0.4   // 1.0 − 0.6

                Image(systemName: page.illustration)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color.accent.opacity(0.8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: parallax)
            }

            // Bottom half — eyebrow, headline, caption
            VStack(spacing: Spacing.lg) {
                Text(String(format: "%02d / %02d", index + 1, pages.count))
                    .eyebrowStyle()

                Text(page.headline)
                    .font(.h1)
                    .foregroundStyle(Color.ink)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.caption)
                    .font(.bodyText)
                    .foregroundStyle(Color.inkSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }

    // MARK: - Dots

    private var pageDots: some View {
        HStack(spacing: 10) {
            ForEach(pages.indices, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.accent : Color.divider)
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.0 : 0.85)
                    .animation(.spring(response: 0.3, dampingFraction: 0.75), value: currentPage)
            }
        }
    }

    // MARK: - Actions

    private func advance() {
        if isLastPage {
            onContinue()
        } else {
            withAnimation(.easeInOut(duration: 0.45)) {
                scrollID = currentPage + 1
            }
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
