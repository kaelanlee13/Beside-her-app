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
                            // Week number badge
                            ZStack {
                                Circle()
                                    .fill(week.weekNumber == profile.currentWeek
                                          ? Color(hex: "3B7DD8")
                                          : Color(hex: "E8F0FE"))
                                    .frame(width: 40, height: 40)
                                
                                Text("\(week.weekNumber)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(week.weekNumber == profile.currentWeek
                                                     ? .white
                                                     : Color(hex: "3B7DD8"))
                            }
                            
                            // Week info
                            VStack(alignment: .leading, spacing: 3) {
                                Text(week.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "1A2B42"))
                                    .lineLimit(1)
                                
                                Text("Baby size: \(week.sizeComparison)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "5A6B80"))
                            }
                            
                            Spacer()
                            
                            // Current week indicator
                            if week.weekNumber == profile.currentWeek {
                                Text("NOW")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(Color(hex: "E8F0FE"))
                                    )
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "8E9BAD"))
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(week.weekNumber == profile.currentWeek
                                        ? Color(hex: "3B7DD8").opacity(0.3)
                                        : Color(hex: "E4EAF1"), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color(hex: "F7F9FC"))
        .navigationTitle("All Weeks")
        .navigationBarTitleDisplayMode(.large)
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
