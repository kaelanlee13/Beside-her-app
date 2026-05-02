//
//  TipsCategoryView.swift
//  BesideHer
//
//  Browse tips organized by category
//

import SwiftUI

struct TipsCategoryView: View {
    let profile: UserProfile
    let content = ContentService.shared

    let categories: [(id: String, name: String, icon: String, color: String)] = [
        ("emotional-support", "Emotional Support",      "heart.fill",                    "E84D6A"),
        ("financial-prep",    "Financial Prep",         "dollarsign.circle.fill",        "56B89F"),
        ("home-gear",         "Home & Gear",            "house.fill",                    "E8963F"),
        ("labor-prep",        "Labor Prep",             "cross.case.fill",               "3B7DD8"),
        ("postpartum-prep",   "Postpartum Prep",        "figure.and.child.holdinghands", "8B6CC1"),
    ]

    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(categories, id: \.id) { category in
                    let tips = content.tips(forCategory: category.id)

                    NavigationLink(destination: TipsListView(
                        categoryName: category.name,
                        tips: tips,
                        profile: profile
                    )) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: category.color).opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: category.icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: category.color))
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(category.name)
                                    .font(.h2)
                                    .foregroundStyle(Color.ink)
                                Text("\(tips.count) tips")
                                    .font(.captionText)
                                    .foregroundStyle(Color.inkSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.inkSecondary)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(Color.surface)
                                .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(Color.divider, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.paper.ignoresSafeArea())
        .navigationTitle("Support Tips")
        .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
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
            VStack(spacing: 12) {

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        TrimesterFilterPill(label: "All", isSelected: selectedTrimester == nil) {
                            withAnimation(.easeInOut(duration: 0.2)) { selectedTrimester = nil }
                        }
                        ForEach([1, 2, 3], id: \.self) { tri in
                            TrimesterFilterPill(label: "Trimester \(tri)", isSelected: selectedTrimester == tri) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTrimester = selectedTrimester == tri ? nil : tri
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 4)

                ForEach(filteredTips) { tip in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(tip.title)
                                .font(.h2)
                                .foregroundStyle(Color.ink)

                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    profile.toggleBookmark(tip.id)
                                }
                            }) {
                                Image(systemName: profile.isTipBookmarked(tip.id) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 14))
                                    .foregroundStyle(profile.isTipBookmarked(tip.id) ? Color.accent : Color.inkSecondary)
                            }
                        }

                        Text(tip.content)
                            .font(.bodyText)
                            .foregroundStyle(Color.inkSecondary)
                            .lineSpacing(4)

                        HStack(spacing: 6) {
                            ForEach(tip.trimester, id: \.self) { tri in
                                Text("T\(tri)")
                                    .font(.captionText.weight(.semibold))
                                    .foregroundStyle(Color.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(Color.accentSoft)
                                    )
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(Color.surface)
                            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(Color.divider, lineWidth: 1)
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
}

// MARK: - Trimester Filter Pill

private struct TrimesterFilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.captionText.weight(.semibold))
                .foregroundColor(isSelected ? .white : Color.inkSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule().fill(isSelected ? Color.accent : Color.surface)
                )
                .overlay(
                    Capsule().stroke(isSelected ? Color.clear : Color.divider, lineWidth: 1)
                )
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
