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
            VStack(spacing: 0) {

                // ─── Hero ────────────────────────────────────────────────
                heroHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // ─── Baby Development ────────────────────────────────────
                sectionCard(
                    systemImage: "figure.child",
                    accentColor: AppTheme.primary,
                    title: "Baby Development",
                    body: week.babyDevelopment
                )
                .padding(.horizontal, 20)
                .padding(.top, 14)

                // ─── Partner Experience ──────────────────────────────────
                sectionCard(
                    systemImage: "figure.arms.open",
                    accentColor: AppTheme.accent,
                    title: "Partner Experience",
                    body: week.partnerExperience
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // ─── How to Help ─────────────────────────────────────────
                howToHelpCard
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                // ─── Action Items ────────────────────────────────────────
                if !week.actionItems.isEmpty || !weekChecklistItems.isEmpty {
                    actionItemsCard
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }

                // ─── Common Dad Question ─────────────────────────────────
                if let question = week.commonDadQuestion, let answer = week.commonDadAnswer {
                    dadQuestionCard(question: question, answer: answer)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }

                // ─── Week Navigation ─────────────────────────────────────
                weekNavRow
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppTheme.heroGradient)

            VStack(alignment: .leading, spacing: 0) {
                // Trimester / month pill
                Text("Trimester \(week.trimester)  ·  \(trimesterMonth)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(.white.opacity(0.65))

                // Large serif week number
                Text("Week \(week.weekNumber)")
                    .font(AppTheme.serifHero(size: 56))
                    .foregroundColor(.white)
                    .padding(.top, 2)

                // Week title
                Text(week.title)
                    .font(AppTheme.serifTitle(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 4)

                Divider()
                    .background(.white.opacity(0.2))
                    .padding(.vertical, 14)

                // Baby size row
                HStack(spacing: 10) {
                    Text(week.sizeEmoji)
                        .font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SIZE THIS WEEK")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
                            .tracking(1.0)
                        Text(week.sizeComparison)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .shadow(color: AppTheme.deepNavy.opacity(0.3), radius: 12, y: 6)
    }

    // MARK: - Section Card (Baby Dev / Partner Exp)

    private func sectionCard(systemImage: String, accentColor: Color, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }

            Text(body)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(whiteCard)
    }

    // MARK: - How to Help Card

    private var howToHelpCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.10))
                        .frame(width: 32, height: 32)
                    Image(systemName: "hands.sparkles")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.green)
                }
                Text("How to Help")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }

            ForEach(week.howToHelp, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(AppTheme.primary)
                        .frame(width: 5, height: 5)
                        .padding(.top, 7)
                    Text(tip)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(whiteCard)
    }

    // MARK: - Action Items Card

    private var actionItemsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Action Items")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)

            ForEach(week.actionItems) { item in
                taskRow(
                    text: item.text,
                    subtitle: item.category.capitalized,
                    isCompleted: profile.isActionItemCompleted(item.id),
                    onToggle: { profile.toggleActionItem(item.id) }
                )

                if item.id != week.actionItems.last?.id || !weekChecklistItems.isEmpty {
                    Divider().padding(.leading, 34)
                }
            }

            ForEach(weekChecklistItems) { item in
                taskRow(
                    text: item.text,
                    subtitle: item.categoryDisplayName,
                    isCompleted: profile.isChecklistItemCompleted(item.id),
                    onToggle: { profile.toggleChecklistItem(item.id) }
                )

                if item.id != weekChecklistItems.last?.id {
                    Divider().padding(.leading, 34)
                }
            }
        }
        .padding(16)
        .background(whiteCard)
    }

    private func taskRow(text: String, subtitle: String, isCompleted: Bool, onToggle: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { onToggle() }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(isCompleted ? AppTheme.primary : .clear)
                        .frame(width: 22, height: 22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isCompleted ? Color.clear : AppTheme.border, lineWidth: 1.5)
                        )
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(isCompleted ? AppTheme.textTertiary : AppTheme.textPrimary)
                    .strikethrough(isCompleted, color: AppTheme.textTertiary)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textTertiary)
            }
        }
    }

    // MARK: - Dad Question Card

    private func dadQuestionCard(question: String, answer: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.25)) {
                showDadAnswer.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.primary)
                        Text("Common Dad Question")
                            .font(AppTheme.captionFont.weight(.semibold))
                            .foregroundColor(AppTheme.primary)
                    }
                    Spacer()
                    Image(systemName: showDadAnswer ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.primary)
                }

                Text(question)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if showDadAnswer {
                    Divider()
                    Text(answer)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.primary.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Week Navigation

    private var weekNavRow: some View {
        HStack {
            if week.weekNumber > 1, let prev = previousWeek {
                NavigationLink(destination: WeekDetailView(week: prev, profile: profile)) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Week \(previousWeekNumber)")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                }
            }
            Spacer()
            if week.weekNumber < 40, let next = nextWeek {
                NavigationLink(destination: WeekDetailView(week: next, profile: profile)) {
                    HStack(spacing: 4) {
                        Text("Week \(nextWeekNumber)")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }

    // MARK: - Shared Style

    private var whiteCard: some View {
        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
            .fill(AppTheme.card)
            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
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

    private var sortedWeekNumbers: [Int] {
        content.weeks.map { $0.weekNumber }.sorted()
    }

    private var previousWeekNumber: Int {
        if let index = sortedWeekNumbers.firstIndex(of: week.weekNumber), index > 0 {
            return sortedWeekNumbers[index - 1]
        }
        return week.weekNumber - 1
    }

    private var nextWeekNumber: Int {
        if let index = sortedWeekNumbers.firstIndex(of: week.weekNumber), index < sortedWeekNumbers.count - 1 {
            return sortedWeekNumbers[index + 1]
        }
        return week.weekNumber + 1
    }

    private var previousWeek: Week? {
        content.week(for: previousWeekNumber)
    }

    private var nextWeek: Week? {
        content.week(for: nextWeekNumber)
    }
}

#Preview {
    let week = ContentService.shared.weeks[5]
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
