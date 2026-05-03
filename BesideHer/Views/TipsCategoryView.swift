//
//  TipsCategoryView.swift
//  BesideHer
//

import SwiftUI

struct TipsCategoryView: View {
    let profile: UserProfile
    let content = ContentService.shared

    @State private var selectedCategoryId: String? = nil

    private let categories: [(id: String, name: String, icon: String, color: String, caption: String)] = [
        ("emotional-support", "Emotional Support",  "heart.fill",                    "E84D6A", "Being present for every moment"),
        ("financial-prep",    "Financial Prep",      "dollarsign.circle.fill",        "56B89F", "Plan ahead so you can be present"),
        ("home-gear",         "Home & Gear",         "house.fill",                    "E8963F", "Get the nursery ready together"),
        ("labor-prep",        "Labor Prep",          "cross.case.fill",               "3B7DD8", "Know what to expect when it begins"),
        ("postpartum-prep",   "Postpartum Prep",     "figure.and.child.holdinghands", "8B6CC1", "Support her through the fourth trimester"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    ForEach(categories, id: \.id) { category in
                        let tips = content.tips(forCategory: category.id)
                        EditorialCard(
                            eyebrow: "\(tips.count) TIPS",
                            headline: category.name,
                            caption: category.caption,
                            illustrationName: category.icon,
                            tintColor: Color(hex: category.color),
                            action: { selectedCategoryId = category.id }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.paper.ignoresSafeArea())
            .navigationTitle("Support Tips")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedCategoryId) { categoryId in
                if let cat = categories.first(where: { $0.id == categoryId }) {
                    TipsListView(
                        categoryName: cat.name,
                        tips: content.tips(forCategory: categoryId),
                        profile: profile
                    )
                }
            }
        }
    }
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
            VStack(spacing: Spacing.md) {

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

                ForEach(filteredTips) { tip in
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack(alignment: .top) {
                            Text(tip.title)
                                .font(.h2)
                                .foregroundStyle(Color.ink)

                            Spacer()

                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    profile.toggleBookmark(tip.id)
                                }
                            }) {
                                Image(systemName: profile.isTipBookmarked(tip.id) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 14))
                                    .foregroundStyle(profile.isTipBookmarked(tip.id) ? Color.accent : Color.inkSecondary)
                            }
                            .buttonStyle(.plain)
                        }

                        Text(tip.content)
                            .font(.bodyText)
                            .foregroundStyle(Color.inkSecondary)
                            .lineSpacing(4)

                        if !tip.trimester.isEmpty {
                            HStack(spacing: Spacing.xs) {
                                ForEach(tip.trimester, id: \.self) { tri in
                                    Text("T\(tri)")
                                        .font(.eyebrow)
                                        .foregroundStyle(Color.accent)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.accentSoft))
                                }
                            }
                        }
                    }
                    .padding(Spacing.xl)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .fill(Color.surface)
                            .premiumShadow()
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .strokeBorder(Color.divider, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
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

#Preview {
    NavigationStack {
        TipsCategoryView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
            onboardingCompleted: true
        ))
    }
}
