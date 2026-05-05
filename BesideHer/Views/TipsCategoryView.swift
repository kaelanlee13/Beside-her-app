//
//  TipsCategoryView.swift
//  BesideHer
//

import SwiftUI

struct TipsCategoryView: View {
    let profile: UserProfile
    let content = ContentService.shared

    @State private var path = NavigationPath()

    private let categories: [(id: String, name: String, icon: String, tint: Color, caption: String)] = [
        ("emotional-support", "Emotional Support",  "heart.fill",                    Color.accent,        "Being present for every moment"),
        ("financial-prep",    "Financial Prep",      "dollarsign.circle.fill",        Color.sage,          "Plan ahead so you can be present"),
        ("home-gear",         "Home & Gear",         "house.fill",                    Color.clay,          "Get the nursery ready together"),
        ("labor-prep",        "Labor Prep",          "cross.case.fill",               Color.alert,         "Know what to expect when it begins"),
        ("postpartum-prep",   "Postpartum Prep",     "figure.and.child.holdinghands", Color.inkSecondary,  "Support her through the fourth trimester"),
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    ForEach(categories, id: \.id) { category in
                        let tips = content.tips(forCategory: category.id)
                        EditorialCard(
                            eyebrow: "\(tips.count) ARTICLES",
                            headline: category.name,
                            caption: category.caption,
                            illustrationName: category.icon,
                            tintColor: category.tint,
                            action: {
                                path.append(TipsCategoryRef(id: category.id))
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .softScrollEdgeEffect()
            .background(Color.paper.ignoresSafeArea())
            .navigationTitle("Support Tips")
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
}

private struct TipsCategoryRef: Hashable {
    let id: String
}

// MARK: - Tips List View

struct TipsListView: View {
    let categoryName: String
    let tips: [Tip]
    let profile: UserProfile

    @State private var selectedTrimester: Int? = nil

    var filteredTips: [Tip] {
        guard let tri = selectedTrimester else { return tips }
        return tips.filter { $0.trimester.contains(tri) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        FilterChip(title: "All", isSelected: selectedTrimester == nil) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                selectedTrimester = nil
                            }
                        }
                        ForEach([1, 2, 3], id: \.self) { tri in
                            FilterChip(
                                title: trimesterLabel(tri),
                                isSelected: selectedTrimester == tri,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedTrimester = selectedTrimester == tri ? nil : tri
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 2)
                }
                .scrollIndicators(.hidden)
                .padding(.top, 4)
                .padding(.bottom, Spacing.md)

                if filteredTips.isEmpty {
                    EmptyStateView(
                        illustrationName: "book.closed",
                        headline: "Pick where to start.",
                        caption: "Articles are short and dad-tested.",
                        tintColor: Color.sage
                    )
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredTips.enumerated()), id: \.element.id) { idx, tip in
                            NavigationLink(value: ReadableArticle.article(from: tip, siblings: tips)) {
                                TipIndexRow(
                                    index: idx + 1,
                                    tip: tip,
                                    isBookmarked: profile.isTipBookmarked(tip.id)
                                )
                            }
                            .buttonStyle(.plain)

                            if idx < filteredTips.count - 1 {
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

    private func trimesterLabel(_ tri: Int) -> String {
        switch tri {
        case 1: return "1st Tri"
        case 2: return "2nd Tri"
        case 3: return "3rd Tri"
        default: return "Tri \(tri)"
        }
    }
}

// MARK: - Index row

private struct TipIndexRow: View {
    let index: Int
    let tip: Tip
    let isBookmarked: Bool

    private var readTimeLabel: String {
        let words = tip.content.split { $0.isWhitespace }.count
        let mins = max(1, Int(ceil(Double(words) / 180.0)))
        return "\(mins) MIN READ"
    }

    private var trimesterLabel: String {
        guard !tip.trimester.isEmpty else { return "" }
        return tip.trimester.map { "T\($0)" }.joined(separator: " · ")
    }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: 8) {
                    Text(String(format: "%02d", index))
                        .eyebrowStyle()

                    if !trimesterLabel.isEmpty {
                        Text("·")
                            .font(.eyebrow)
                            .foregroundStyle(Color.inkSecondary)
                        Text(trimesterLabel)
                            .eyebrowStyle()
                    }

                    Spacer()

                    Text(readTimeLabel)
                        .eyebrowStyle()
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
