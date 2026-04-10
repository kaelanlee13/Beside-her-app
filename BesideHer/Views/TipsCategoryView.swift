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
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text("\(tips.count) tips")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textTertiary)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.card)
                                .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Support Tips")
        .navigationBarTitleDisplayMode(.large)
        } // NavigationStack
    }
}

// MARK: - Tips List View

struct TipsListView: View {
    let categoryName: String
    let tips: [Tip]
    let profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(tips) { tip in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(tip.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    profile.toggleBookmark(tip.id)
                                }
                            }) {
                                Image(systemName: profile.isTipBookmarked(tip.id) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(profile.isTipBookmarked(tip.id) ? AppTheme.primary : AppTheme.textTertiary)
                            }
                        }

                        Text(tip.content)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(4)

                        // Trimester tags
                        HStack(spacing: 6) {
                            ForEach(tip.trimester, id: \.self) { tri in
                                Text("T\(tri)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(AppTheme.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(AppTheme.primary.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(AppTheme.card)
                            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
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
