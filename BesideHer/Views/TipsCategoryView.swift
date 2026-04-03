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
        ("emotional-support", "Emotional Support", "heart.fill", "E84D6A"),
        ("financial-prep", "Financial Prep", "dollarsign.circle.fill", "56B89F"),
        ("home-gear", "Home & Gear", "house.fill", "E8963F"),
        ("labor-prep", "Labor Prep", "cross.case.fill", "3B7DD8"),
        ("postpartum-prep", "Postpartum Prep", "figure.and.child.holdinghands", "8B6CC1"),
    ]
    
    var body: some View {
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
                                    .fill(Color(hex: category.color).opacity(0.15))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: category.icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: category.color))
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(category.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "1A2B42"))
                                
                                Text("\(tips.count) tips")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "5A6B80"))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "8E9BAD"))
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color(hex: "F7F9FC"))
        .navigationTitle("Support Tips")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Tips List View (shows all tips in a category)

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
                                .foregroundColor(Color(hex: "1A2B42"))
                            
                            Spacer()
                            
                            // Bookmark button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    profile.toggleBookmark(tip.id)
                                }
                            }) {
                                Image(systemName: profile.isTipBookmarked(tip.id) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(profile.isTipBookmarked(tip.id) ? Color(hex: "3B7DD8") : Color(hex: "8E9BAD"))
                            }
                        }
                        
                        Text(tip.content)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "5A6B80"))
                            .lineSpacing(4)
                        
                        // Trimester tags
                        HStack(spacing: 6) {
                            ForEach(tip.trimester, id: \.self) { tri in
                                Text("T\(tri)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(Color(hex: "E8F0FE"))
                                    )
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color(hex: "F7F9FC"))
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
