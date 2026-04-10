
//
//  WeekDetailView.swift
//  BesideHer
//
//  Full detail view for a specific pregnancy week
//

import SwiftUI

struct WeekDetailView: View {
    let week: Week
    let profile: UserProfile
    let content = ContentService.shared

    @State private var showDadAnswer = false

    var weekChecklistItems: [ChecklistItem] {
        content.checklists.flatMap { $0.items }.filter { $0.weekRecommended == week.weekNumber }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Week header
                VStack(spacing: 4) {
                    Text(week.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "1A2B42"))
                        .multilineTextAlignment(.center)

                    Text("Trimester \(week.trimester) · \(trimesterMonth)")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "5A6B80"))
                }
                .padding(.top, 8)
                .padding(.bottom, 4)

                // Baby Size Illustration Card
                VStack(spacing: 12) {
                    Text("SIZE THIS WEEK")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(hex: "3B7DD8"))
                        .tracking(1.0)

                    ZStack {
                        Circle()
                            .fill(Color(hex: "E8F4F0"))
                            .frame(width: 110, height: 110)
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
                        Text(week.sizeEmoji)
                            .font(.system(size: 62))
                    }

                    Text(week.sizeComparison)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "1A2B42"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                // Baby Development
                sectionCard(
                    icon: "👶",
                    iconBackground: Color(hex: "E8F0FE"),
                    title: "Baby Development",
                    content: week.babyDevelopment
                )

                // Partner Experience
                sectionCard(
                    icon: "🤰",
                    iconBackground: Color(hex: "FEF3E6"),
                    title: "Partner Experience",
                    content: week.partnerExperience
                )

                // How to Help
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(hex: "E6F7F2"))
                                .frame(width: 28, height: 28)
                            Text("💪")
                                .font(.system(size: 14))
                        }
                        Text("How to Help")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "1A2B42"))
                    }

                    ForEach(week.howToHelp, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color(hex: "56B89F"))
                                .frame(width: 5, height: 5)
                                .padding(.top, 7)

                            Text(tip)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "5A6B80"))
                                .lineSpacing(3)
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
                .padding(.horizontal, 20)

                // Action Items
                VStack(alignment: .leading, spacing: 10) {
                    Text("Action Items")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "1A2B42"))

                    ForEach(week.actionItems) { item in
                        HStack(spacing: 12) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    profile.toggleActionItem(item.id)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(profile.isActionItemCompleted(item.id) ? Color(hex: "3B7DD8") : .clear)
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(profile.isActionItemCompleted(item.id) ? Color.clear : Color(hex: "E4EAF1"), lineWidth: 1.5)
                                        )

                                    if profile.isActionItemCompleted(item.id) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(profile.isActionItemCompleted(item.id) ? Color(hex: "8E9BAD") : Color(hex: "1A2B42"))
                                    .strikethrough(profile.isActionItemCompleted(item.id))

                                Text(item.category.capitalized)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "8E9BAD"))
                            }
                        }

                        if item.id != week.actionItems.last?.id || !weekChecklistItems.isEmpty {
                            Divider()
                        }
                    }

                    ForEach(weekChecklistItems) { item in
                        HStack(spacing: 12) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    profile.toggleChecklistItem(item.id)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(profile.isChecklistItemCompleted(item.id) ? Color(hex: "3B7DD8") : .clear)
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(profile.isChecklistItemCompleted(item.id) ? Color.clear : Color(hex: "E4EAF1"), lineWidth: 1.5)
                                        )

                                    if profile.isChecklistItemCompleted(item.id) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(profile.isChecklistItemCompleted(item.id) ? Color(hex: "8E9BAD") : Color(hex: "1A2B42"))
                                    .strikethrough(profile.isChecklistItemCompleted(item.id))

                                Text(item.categoryDisplayName)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "8E9BAD"))
                            }
                        }

                        if item.id != weekChecklistItems.last?.id {
                            Divider()
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
                .padding(.horizontal, 20)

                // Common Dad Question
                if let question = week.commonDadQuestion, let answer = week.commonDadAnswer {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showDadAnswer.toggle()
                        }
                    }) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Common Dad Question")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                                    .tracking(0.5)
                                Spacer()
                                Image(systemName: showDadAnswer ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                            }

                            Text(question)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "1A2B42"))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if showDadAnswer {
                                Divider()
                                    .background(Color(hex: "3B7DD8").opacity(0.2))

                                Text(answer)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "5A6B80"))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "E8F0FE"))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                }

                // Week navigation
                HStack {
                    if week.weekNumber > 1 {
                        Button(action: {}) {
                            Text("← Week \(previousWeekNumber)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "3B7DD8"))
                        }
                    }
                    Spacer()
                    if week.weekNumber < 40 {
                        Button(action: {}) {
                            Text("Week \(nextWeekNumber) →")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "3B7DD8"))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .background(Color(hex: "F7F9FC"))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Views

    private func sectionCard(icon: String, iconBackground: Color, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(iconBackground)
                        .frame(width: 28, height: 28)
                    Text(icon)
                        .font(.system(size: 14))
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1A2B42"))
            }

            Text(content)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "5A6B80"))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .padding(.horizontal, 20)
    }

    // MARK: - Computed Properties

    private var trimesterMonth: String {
        let monthMap: [Int: String] = [
            1: "Month 1", 4: "Month 1", 5: "Month 2", 6: "Month 2",
            7: "Month 2", 8: "Month 2", 9: "Month 3", 10: "Month 3",
            11: "Month 3", 12: "Month 3", 13: "Month 3",
            14: "Month 4", 15: "Month 4", 16: "Month 4", 17: "Month 4",
            18: "Month 5", 19: "Month 5", 20: "Month 5", 21: "Month 5",
            22: "Month 6", 23: "Month 6", 24: "Month 6", 25: "Month 6",
            26: "Month 7", 27: "Month 7",
            28: "Month 7", 29: "Month 7", 30: "Month 8", 31: "Month 8",
            32: "Month 8", 33: "Month 8", 34: "Month 8", 35: "Month 9",
            36: "Month 9", 37: "Month 9", 38: "Month 9", 39: "Month 10",
            40: "Month 10"
        ]
        return monthMap[week.weekNumber] ?? "Month \(week.weekNumber / 4 + 1)"
    }

    private var previousWeekNumber: Int {
        let weeks = content.weeks.map { $0.weekNumber }.sorted()
        if let index = weeks.firstIndex(of: week.weekNumber), index > 0 {
            return weeks[index - 1]
        }
        return week.weekNumber - 1
    }

    private var nextWeekNumber: Int {
        let weeks = content.weeks.map { $0.weekNumber }.sorted()
        if let index = weeks.firstIndex(of: week.weekNumber), index < weeks.count - 1 {
            return weeks[index + 1]
        }
        return week.weekNumber + 1
    }
}

#Preview {
    let week = ContentService.shared.weeks[5] // Week 8
    NavigationStack {
        WeekDetailView(
            week: week,
            profile: UserProfile(
                dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
                onboardingCompleted: true
            )
        )
    }
}
