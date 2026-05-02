//
//  AllWeeksView.swift
//  BesideHer
//
//  Browse all 40 weeks of pregnancy content
//

import SwiftUI

struct AllWeeksView: View {
    let profile: UserProfile
    let content = ContentService.shared

    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(content.weeks) { week in
                    NavigationLink(destination: WeekDetailView(week: week, profile: profile)) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(week.weekNumber == profile.currentWeek
                                          ? Color.accent
                                          : Color.accentSoft)
                                    .frame(width: 40, height: 40)

                                Text("\(week.weekNumber)")
                                    .font(.captionText.weight(.bold))
                                    .foregroundColor(week.weekNumber == profile.currentWeek
                                                     ? Color.onAccent
                                                     : Color.accent)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(week.title)
                                    .font(.h2)
                                    .foregroundStyle(Color.ink)
                                    .lineLimit(1)

                                Text("Baby size: \(week.sizeComparison)")
                                    .font(.captionText)
                                    .foregroundStyle(Color.inkSecondary)
                            }

                            Spacer()

                            if week.weekNumber == profile.currentWeek {
                                Text("NOW")
                                    .font(.captionText.weight(.bold))
                                    .foregroundStyle(Color.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(Color.accentSoft)
                                    )
                            }

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.inkSecondary)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.surface)
                                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(week.weekNumber == profile.currentWeek
                                        ? Color.accent.opacity(0.3)
                                        : Color.divider, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.paper)
        .navigationTitle("All Weeks")
        .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
    }
}

#Preview {
    NavigationStack {
        AllWeeksView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
            onboardingCompleted: true
        ))
    }
}
