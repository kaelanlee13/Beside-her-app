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

                // ─── Week Navigation ─────────────────────────────────────
                weekNavRow
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // ─── Hero ────────────────────────────────────────────────
                heroHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                // ─── Baby Development ────────────────────────────────────
                sectionCard(
                    systemImage: "figure.child",
                    accentColor: Color.ink,
                    eyebrow: "DEVELOPMENT",
                    title: "Baby Development",
                    body: week.babyDevelopment
                )
                .padding(.horizontal, 20)
                .padding(.top, 14)

                // ─── Partner Experience ──────────────────────────────────
                sectionCard(
                    systemImage: "figure.arms.open",
                    accentColor: Color.clay,
                    eyebrow: "YOUR PARTNER",
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

                Spacer(minLength: 32)
            }
        }
        .background(Color.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.paperTinted)

            VStack(alignment: .leading, spacing: 0) {
                Text("Trimester \(week.trimester)  ·  \(trimesterMonth)")
                    .font(.captionText)
                    .foregroundStyle(Color.inkSecondary)

                Text("Week \(week.weekNumber)")
                    .font(.hero)
                    .foregroundStyle(Color.ink)
                    .padding(.top, 2)

                Text(week.title)
                    .font(.h2)
                    .foregroundStyle(Color.ink.opacity(0.85))
                    .padding(.top, 4)

                Divider()
                    .background(Color.divider)
                    .padding(.vertical, 14)

                HStack(spacing: 10) {
                    // TODO: replace size illustration — need asset for "\(week.sizeComparison)" (e.g. apple, lemon, papaya)
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.accent.opacity(0.55))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SIZE THIS WEEK")
                            .eyebrowStyle()
                        Text(week.sizeComparison)
                            .font(.bodyText.weight(.semibold))
                            .foregroundStyle(Color.ink)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .premiumShadow()
    }

    // MARK: - Section Card (Baby Dev / Partner Exp)

    private func sectionCard(systemImage: String, accentColor: Color, eyebrow: String, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow)
                .eyebrowStyle()

            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.input)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(accentColor)
                }
                Text(title)
                    .font(.h2)
                    .foregroundStyle(Color.ink)
            }

            Text(body)
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(surfaceCard)
    }

    // MARK: - How to Help Card

    private var howToHelpCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR ROLE")
                .eyebrowStyle()

            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.input)
                        .fill(Color.sage.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: "hands.sparkles")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.sage)
                }
                Text("How to Help")
                    .font(.h2)
                    .foregroundStyle(Color.ink)
            }

            ForEach(week.howToHelp, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.sage)
                        .frame(width: 5, height: 5)
                        .padding(.top, 7)
                    Text(tip)
                        .font(.bodyText)
                        .foregroundStyle(Color.inkSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(surfaceCard)
    }

    // MARK: - Action Items Card

    private var actionItemsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR TASKS")
                .eyebrowStyle()

            Text("Action Items")
                .font(.h2)
                .foregroundStyle(Color.ink)

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
        .background(surfaceCard)
    }

    private func taskRow(text: String, subtitle: String, isCompleted: Bool, onToggle: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { onToggle() }
            }) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.accent : .clear)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .stroke(isCompleted ? Color.clear : Color.divider, lineWidth: 1.5)
                        )
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.onAccent)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.bodyText)
                    .foregroundStyle(isCompleted ? Color.inkSecondary : Color.ink)
                    .strikethrough(isCompleted, color: Color.inkSecondary)
                Text(subtitle)
                    .font(.captionText)
                    .foregroundStyle(Color.inkSecondary)
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
                            .foregroundStyle(Color.inkSecondary)
                        Text("DAD QUESTION")
                            .eyebrowStyle()
                    }
                    Spacer()
                    Image(systemName: showDadAnswer ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.inkSecondary)
                }

                Text(question)
                    .font(.h2)
                    .foregroundStyle(Color.ink)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if showDadAnswer {
                    Divider()
                    Text(answer)
                        .font(.bodyText)
                        .foregroundStyle(Color.inkSecondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.accentSoft)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Week Navigation

    private var weekNavRow: some View {
        HStack(spacing: 10) {
            if week.weekNumber > 1, let prev = previousWeek {
                NavigationLink(destination: WeekDetailView(week: prev, profile: profile)) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Week \(previousWeekNumber)")
                            .font(.captionText.weight(.semibold))
                    }
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.input)
                            .fill(Color.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.input)
                            .stroke(Color.divider, lineWidth: 1)
                    )
                }
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }

            if week.weekNumber < 40, let next = nextWeek {
                NavigationLink(destination: WeekDetailView(week: next, profile: profile)) {
                    HStack(spacing: 4) {
                        Text("Week \(nextWeekNumber)")
                            .font(.captionText.weight(.semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.input)
                            .fill(Color.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.input)
                            .stroke(Color.divider, lineWidth: 1)
                    )
                }
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
        }
    }

    // MARK: - Shared Style

    private var surfaceCard: some View {
        RoundedRectangle(cornerRadius: Radius.card)
            .fill(Color.surface)
            .premiumShadow()
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(Color.divider, lineWidth: 1)
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
