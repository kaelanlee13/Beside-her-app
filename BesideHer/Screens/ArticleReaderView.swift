//
//  ArticleReaderView.swift
//  BesideHer
//
//  Premium long-form reading view for an individual Tips article.
//

import SwiftUI

// MARK: - Article model

struct ReadableArticle: Identifiable, Hashable {
    let id: String
    let category: String
    let readTimeMinutes: Int
    let title: String
    let authorName: String
    let publishedDate: String
    let pullQuote: String?
    let paragraphs: [String]
    let relatedTitles: [String]

    static let sampleEmotionalSupport = ReadableArticle(
        id: "sample-third-trimester-presence",
        category: "Emotional Support",
        readTimeMinutes: 6,
        title: "How to actually be present during the third trimester",
        authorName: "BesideHer Editors",
        publishedDate: "March 14, 2026",
        pullQuote: "Presence isn't a single grand gesture — it's the small, repeatable act of choosing her over your phone, your inbox, your endless scroll.",
        paragraphs: [
            "By the third trimester, your partner has been carrying another human for more than half a year. Her hips ache in ways she can't fully describe. Sleep has become a negotiation between her bladder, the baby's elbows, and a body that doesn't quite fit any pillow configuration she tries. The finish line feels close enough to taste and impossibly far at the same time. What she needs from you in these final weeks is rarely heroic. It's quieter than that, and harder than it looks.",
            "Most first-time dads think being present means being available — physically in the room, ready to fetch ice water or rub a sore foot. That matters, but it's the floor, not the ceiling. The presence she actually feels is the kind that requires you to put your phone face-down on the counter when she walks in, to ask a follow-up question instead of a closing one, to stay in the conversation past the point where you would normally drift back to your own thoughts. It's attention as a gift, given on purpose, again and again.",
            "Try this for a week: when she tells you something — about a kick that surprised her, about a coworker who said the wrong thing, about the fact that she's suddenly terrified of nothing in particular — don't fix it. Don't pivot to logistics. Don't reach for reassurance. Just stay. Reflect back what you heard. Ask her what part felt heaviest. You'll be amazed how often that's the entire conversation she needed, and how rarely she gets it from anyone else.",
            "There will be evenings she snaps at you for something that isn't your fault, and mornings she cries about a commercial. Her hormones are doing the work of preparing her body to do something extraordinary, and the side effects are real. Your job in those moments is not to take it personally and not to pretend it isn't happening. Acknowledge it gently, give her the room she needs, and come back. Coming back is the part most men skip. It's the part that builds the trust she'll need when labor starts and the world gets loud.",
            "And here's the quiet truth nobody tells you: the muscle you're building right now — the muscle of choosing her presence over your distractions — is the same muscle you'll need on the other side. The baby will arrive. The nights will get harder. The version of you who learned, in these final weeks, how to actually show up for the woman in front of him is the version of you who will know how to show up for the family you're about to have. Start now. It compounds.",
        ],
        relatedTitles: [
            "Conversations to have before the baby arrives",
            "When her body changes faster than her mood",
        ]
    )
}

// MARK: - Reader view

struct ArticleReaderView: View {
    let article: ReadableArticle

    @Environment(\.dismiss) private var dismiss

    @State private var isBookmarked: Bool = false
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 1
    @State private var viewportHeight: CGFloat = 1

    private var progress: CGFloat {
        let scrollable = max(contentHeight - viewportHeight, 1)
        return min(max(scrollOffset / scrollable, 0), 1)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.paper
                .ignoresSafeArea()

            readerScroll

            progressRule
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
    }

    // MARK: Scroll content

    private var readerScroll: some View {
        GeometryReader { outerGeo in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Scroll-offset probe at the very top of the content.
                    Color.clear
                        .frame(height: 0)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ReaderOffsetKey.self,
                                    value: -proxy.frame(in: .named("reader")).origin.y
                                )
                            }
                        )

                    Spacer().frame(height: Spacing.md)

                    Text("\(article.category.uppercased()) · \(article.readTimeMinutes) MIN READ")
                        .eyebrowStyle()

                    Spacer().frame(height: Spacing.md)

                    Text(article.title)
                        .font(.h1)
                        .foregroundStyle(Color.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer().frame(height: Spacing.sm)

                    Text("\(article.authorName) · \(article.publishedDate)")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)

                    Spacer().frame(height: Spacing.xxl)

                    if let quote = article.pullQuote {
                        pullQuote(quote)
                        Spacer().frame(height: Spacing.xxl)
                    }

                    bodyText

                    Spacer().frame(height: Spacing.xxxl)

                    Rectangle()
                        .fill(Color.divider)
                        .frame(height: 1)

                    Spacer().frame(height: Spacing.xl)

                    Text("MORE FROM \(article.category.uppercased())")
                        .eyebrowStyle()

                    Spacer().frame(height: Spacing.md)

                    VStack(spacing: 0) {
                        ForEach(Array(article.relatedTitles.enumerated()), id: \.offset) { index, title in
                            relatedRow(title: title)
                            if index < article.relatedTitles.count - 1 {
                                Rectangle()
                                    .fill(Color.divider)
                                    .frame(height: 1)
                            }
                        }
                    }

                    Spacer().frame(height: Spacing.huge)
                }
                .padding(.horizontal, Spacing.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: ReaderHeightKey.self,
                            value: proxy.size.height
                        )
                    }
                )
            }
            .coordinateSpace(name: "reader")
            .onPreferenceChange(ReaderOffsetKey.self) { scrollOffset = $0 }
            .onPreferenceChange(ReaderHeightKey.self) { contentHeight = $0 }
            .onAppear { viewportHeight = outerGeo.size.height }
            .onChange(of: outerGeo.size.height) { _, newValue in
                viewportHeight = newValue
            }
        }
    }

    // MARK: Pull quote

    private func pullQuote(_ text: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.lg) {
            Rectangle()
                .fill(Color.accent)
                .frame(width: 2)

            Text(text)
                .font(.h2)
                .fontDesign(.serif)
                .italic()
                .foregroundStyle(Color.ink)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Body

    private var bodyText: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            ForEach(Array(article.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(.system(size: 19, design: .serif))
                    .foregroundStyle(Color.ink)
                    .lineSpacing(8)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: Related rows

    private func relatedRow(title: String) -> some View {
        HStack(alignment: .center, spacing: Spacing.lg) {
            Text(title)
                .font(.h2)
                .foregroundStyle(Color.ink)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: Spacing.md)

            Image(systemName: "arrow.up.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.inkSecondary)
        }
        .padding(.vertical, Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    // MARK: Progress rule

    private var progressRule: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(Color.accent)
                .frame(width: geo.size.width * progress, height: 1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 1)
        .allowsHitTesting(false)
    }

    // MARK: Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.ink)
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isBookmarked.toggle()
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color.ink)
                    .symbolEffect(.bounce, value: isBookmarked)
            }
        }
    }
}

// MARK: - Preference keys

private struct ReaderOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct ReaderHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 1
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ArticleReaderView(article: .sampleEmotionalSupport)
    }
}
