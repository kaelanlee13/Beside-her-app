//
//  TipsCategoryView.swift
//  BesideHer
//

import SwiftUI

struct TipsCategoryView: View {
    let profile: UserProfile
    let content = ContentService.shared

    @State private var path = NavigationPath()
    @State private var selectedSection: TipsSection = .categories

    private let categories: [(id: String, name: String, icon: String, background: Color, iconTint: Color, caption: String)] = [
        ("emotional-support", "Emotional Support",  "heart.fill",                    Color.accent.opacity(0.18), Color.accent.opacity(0.7),  "Being present for every moment"),
        ("financial-prep",    "Financial Prep",      "dollarsign.circle.fill",        Color.sage.opacity(0.18),   Color.sage.opacity(0.85),   "Plan ahead so you can be present"),
        ("home-gear",         "Home & Gear",         "house.fill",                    Color.clay.opacity(0.22),   Color.accent.opacity(0.7),  "Get the nursery ready together"),
        ("labor-prep",        "Labor Prep",          "cross.case.fill",               Color.accent.opacity(0.10), Color.accent.opacity(0.7),  "Know what to expect when it begins"),
        ("postpartum-prep",   "Postpartum Prep",     "figure.and.child.holdinghands", Color.sage.opacity(0.10),   Color.accent.opacity(0.7),  "Support her through the fourth trimester"),
    ]

    private var bookmarkedTips: [Tip] {
        content.tips(withIDs: profile.bookmarkedTips)
    }

    private var totalArticleCount: Int {
        categories.reduce(0) { $0 + content.tips(forCategory: $1.id).count }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 0) {
                    masthead

                    sectionSelector
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        .padding(.bottom, Spacing.md)

                    switch selectedSection {
                    case .categories:
                        categoriesList
                    case .bookmarks:
                        bookmarksList
                    }
                }
                .padding(.vertical, 12)
            }
            .softScrollEdgeEffect()
            .background(Color.paper.ignoresSafeArea())
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: TipsCategoryRef.self) { ref in
                if let cat = categories.first(where: { $0.id == ref.id }) {
                    TipsListView(
                        categoryName: cat.name,
                        tips: content.tips(forCategory: ref.id),
                        profile: profile
                    )
                }
            }
            .navigationDestination(for: ReadableArticle.self) { article in
                ArticleReaderView(article: article, profile: profile)
            }
        }
    }

    // MARK: - Masthead

    private var masthead: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("GUIDES")
                .font(.eyebrow)
                .eyebrowStyle()
            Text("Tips")
                .font(.h1)
                .foregroundStyle(Color.ink)
            Text("\(categories.count) sections · \(totalArticleCount) articles")
                .font(.captionText)
                .foregroundStyle(Color.inkSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.lg)
    }

    // MARK: - Sections

    private var sectionSelector: some View {
        HStack(spacing: Spacing.sm) {
            FilterChip(title: "Categories", isSelected: selectedSection == .categories) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedSection = .categories
                }
            }
            FilterChip(title: "Bookmarks", isSelected: selectedSection == .bookmarks) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedSection = .bookmarks
                }
            }
            Spacer()
        }
    }

    private var categoriesList: some View {
        VStack(spacing: Spacing.md) {
            ForEach(categories, id: \.id) { category in
                let tips = content.tips(forCategory: category.id)
                EditorialCard(
                    eyebrow: "\(tips.count) ARTICLES",
                    headline: category.name,
                    caption: category.caption,
                    illustrationName: category.icon,
                    backgroundTint: category.background,
                    iconTint: category.iconTint,
                    action: {
                        path.append(TipsCategoryRef(id: category.id))
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var bookmarksList: some View {
        let bookmarks = bookmarkedTips
        if bookmarks.isEmpty {
            EmptyStateView(
                illustrationName: "bookmark",
                headline: "No bookmarks yet.",
                caption: "Tap the bookmark icon on any article to save it here.",
                tintColor: Color.accent
            )
            .padding(.top, Spacing.xl)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(Array(bookmarks.enumerated()), id: \.element.id) { idx, tip in
                    NavigationLink(value: ReadableArticle.article(from: tip, siblings: bookmarks)) {
                        TipIndexRow(
                            tip: tip,
                            isBookmarked: true
                        )
                    }
                    .buttonStyle(.plain)

                    if idx < bookmarks.count - 1 {
                        Rectangle()
                            .fill(Color.divider)
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

private enum TipsSection {
    case categories, bookmarks
}

private struct TipsCategoryRef: Hashable {
    let id: String
}

// MARK: - Tips List View

struct TipsListView: View {
    let categoryName: String
    let tips: [Tip]
    let profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if tips.isEmpty {
                    EmptyStateView(
                        illustrationName: "book.closed",
                        headline: "Pick where to start.",
                        caption: "Articles are short and dad-tested.",
                        tintColor: Color.sage
                    )
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(tips.enumerated()), id: \.element.id) { idx, tip in
                            NavigationLink(value: ReadableArticle.article(from: tip, siblings: tips)) {
                                TipIndexRow(
                                    tip: tip,
                                    isBookmarked: profile.isTipBookmarked(tip.id)
                                )
                            }
                            .buttonStyle(.plain)

                            if idx < tips.count - 1 {
                                Rectangle()
                                    .fill(Color.divider)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .background(Color.paper.ignoresSafeArea())
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Index row

private struct TipIndexRow: View {
    let tip: Tip
    let isBookmarked: Bool

    private var readTimeLabel: String {
        let mins = ReadableArticle.leaf(from: tip).readTimeMinutes
        return "\(mins) MIN READ"
    }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: 8) {
                    Text(readTimeLabel)
                        .eyebrowStyle()

                    Spacer()
                }

                Text(tip.title)
                    .font(.h2)
                    .foregroundStyle(Color.ink)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(tip.content)
                    .font(.bodyText)
                    .foregroundStyle(Color.inkSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            VStack {
                if isBookmarked {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.accent)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        TipsCategoryView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
            onboardingCompleted: true
        ))
    }
}
