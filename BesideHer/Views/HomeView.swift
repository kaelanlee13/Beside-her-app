//
//  HomeView.swift
//  BesideHer
//
//  Main home screen — hero card, progress, tasks, dad question
//

import SwiftUI

struct HomeView: View {
    let profile: UserProfile
    let content = ContentService.shared

    var currentWeekContent: Week? {
        content.week(for: profile.currentWeek)
    }

    var weekChecklistItems: [ChecklistItem] {
        content.checklists.flatMap { $0.items }.filter { $0.weekRecommended == profile.currentWeek }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // ─── Top utility row ────────────────────────────────────
                    settingsRow
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // ─── Hero Card ───────────────────────────────────────────
                    heroCard
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                    // ─── Contraction Timer CTA ──────────────────────────────
                    contractionRow
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    // ─── This Week's Tasks ──────────────────────────────────
                    if let week = currentWeekContent {
                        if week.actionItems.isEmpty && weekChecklistItems.isEmpty {
                            EmptyStateView(
                                illustrationName: "leaf",
                                headline: "A quiet week.",
                                caption: "Rest, hydrate, and check in with her.",
                                tintColor: Color.sage
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        } else {
                            tasksCard(week: week)
                                .padding(.horizontal, 20)
                                .padding(.top, 12)
                        }
                    }

                    // ─── Common Dad Question ────────────────────────────────
                    if let week = currentWeekContent,
                       let question = week.commonDadQuestion,
                       let answer = week.commonDadAnswer {
                        dadQuestionCard(question: question, answer: answer)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                    }

                    Spacer(minLength: 32)
                }
            }
            .softScrollEdgeEffect()
            .background(Color.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Settings Row

    private var settingsRow: some View {
        HStack {
            Spacer()
            NavigationLink(destination: SettingsView(profile: profile)) {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color.inkSecondary)
                    .frame(width: 36, height: 36, alignment: .trailing)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Settings")
        }
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        NavigationLink(destination: Group {
            if let week = currentWeekContent {
                WeekDetailView(week: week, profile: profile)
            }
        }) {
            VStack(alignment: .leading, spacing: Spacing.lg) {

                // Eyebrow row with chevron — top-right tappable affordance
                HStack {
                    Text("WEEK \(profile.currentWeek) OF 40")
                        .eyebrowStyle()
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.6), value: profile.currentWeek)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.inkSecondary)
                }

                // Headline + illustration
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(heroHeadlineText)
                        .font(.system(size: 36, weight: .semibold, design: .serif))
                        .foregroundStyle(Color.ink)
                        .lineLimit(3)
                        .minimumScaleFactor(0.85)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TrimesterGlyph(weekNumber: profile.currentWeek, size: 80, tinted: true)
                }

                // Progress ruler + caption — full-width
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.divider)
                                .frame(height: 1)
                            Rectangle()
                                .fill(Color.accent)
                                .frame(width: geo.size.width * min(profile.progressPercentage, 1.0), height: 1)
                                .animation(.easeInOut(duration: 1.2), value: profile.currentWeek)
                        }
                    }
                    .frame(height: 1)

                    Text(heroProgressCaption)
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.6), value: profile.currentWeek)
                }

                // CTA — accent eyebrow inviting the tap
                HStack(spacing: 4) {
                    Text("Read this week's guide")
                    Image(systemName: "arrow.right")
                }
                .eyebrowStyle()
                .foregroundStyle(Color.accent)
                .padding(.top, Spacing.md)
            }
            .padding(Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.paperTinted)
                    .premiumShadow()
            )
        }
        .buttonStyle(.pressable)
        .disabled(currentWeekContent == nil)
    }

    private var heroHeadlineText: String {
        guard let week = currentWeekContent else { return "" }
        let subject: String
        switch profile.babyGender {
        case "boy":  subject = "He's"
        case "girl": subject = "She's"
        default:     subject = "Baby is"
        }
        return "\(subject) the size of \(articleFor(week.sizeComparison)) \(week.sizeComparison.lowercased())"
    }

    private var heroProgressCaption: String {
        let cal = Calendar.current
        let days = cal.dateComponents([.day], from: cal.startOfDay(for: Date()),
                                      to: cal.startOfDay(for: profile.dueDate)).day ?? 0
        switch days {
        case ..<0: return "overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")"
        case 0:    return "due today"
        case 1:    return "1 day to go"
        default:   return "\(days) days to go"
        }
    }

    // MARK: - Contraction Timer

    @ViewBuilder
    private var contractionRow: some View {
        if profile.currentWeek < 36 {
            contractionLinkRow
        } else {
            contractionCard
        }
    }

    private var contractionLinkRow: some View {
        NavigationLink(destination: ContractionTimerView()) {
            HStack {
                Text("CONTRACTION TIMER")
                    .eyebrowStyle()
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .overlay(alignment: .top) {
                Rectangle().fill(Color.divider).frame(height: 1)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Color.divider).frame(height: 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var contractionCard: some View {
        NavigationLink(destination: ContractionTimerView()) {
            HStack(spacing: 14) {
                Image(systemName: "waveform.path")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(Color.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Contraction Timer")
                        .font(.h2)
                        .foregroundStyle(Color.ink)
                    Text("Track contractions during labor")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(16)
            .background(surfaceCard)
        }
        .buttonStyle(.pressable)
    }

    // MARK: - Tasks Card

    private func tasksCard(week: Week) -> some View {
        let checklistItems = weekChecklistItems
        let actionCount = week.actionItems.count
        let totalCount = actionCount + checklistItems.count
        let completedCount = week.actionItems.filter { profile.isActionItemCompleted($0.id) }.count
            + checklistItems.filter { profile.isChecklistItemCompleted($0.id) }.count

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("THIS WEEK")
                    .eyebrowStyle()
                Spacer()
                Text("\(completedCount) of \(totalCount)")
                    .font(.captionText.weight(.semibold))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.bottom, Spacing.md)

            ForEach(Array(week.actionItems.enumerated()), id: \.element.id) { index, item in
                let isLastAction = index == actionCount - 1
                ChecklistRow(
                    title: item.text,
                    isComplete: profile.isActionItemCompleted(item.id),
                    onToggle: { profile.toggleActionItem(item.id) },
                    showDivider: !(isLastAction && checklistItems.isEmpty)
                )
            }

            ForEach(Array(checklistItems.enumerated()), id: \.element.id) { index, item in
                ChecklistRow(
                    title: item.text,
                    isComplete: profile.isChecklistItemCompleted(item.id),
                    onToggle: { profile.toggleChecklistItem(item.id) },
                    showDivider: index < checklistItems.count - 1
                )
            }
        }
        .padding(Spacing.xl)
        .background(surfaceCard)
    }

    // MARK: - Dad Question Card

    private func dadQuestionCard(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.inkSecondary)
                Text("DAD QUESTION")
                    .eyebrowStyle()
            }
            Text(question)
                .font(.h2)
                .foregroundStyle(Color.ink)
            Text(answer)
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .lineSpacing(4)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(surfaceCard)
    }

    // MARK: - Shared Helpers

    private var surfaceCard: some View {
        RoundedRectangle(cornerRadius: Radius.card)
            .fill(Color.surface)
            .premiumShadow()
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(Color.divider, lineWidth: 1)
            )
    }

    private var babyLabel: String {
        switch profile.babyGender {
        case "boy":  return "Baby boy"
        case "girl": return "Baby girl"
        default:     return "Baby"
        }
    }

    private func articleFor(_ word: String) -> String {
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        if let first = word.lowercased().first, vowels.contains(first) { return "an" }
        return "a"
    }
}


#Preview("Week 32 — link row") {
    HomeView(profile: UserProfile(
        dueDate: Calendar.current.date(byAdding: .day, value: 56, to: Date())!,
        onboardingCompleted: true
    ))
}

#Preview("Week 38 — card") {
    HomeView(profile: UserProfile(
        dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
        onboardingCompleted: true
    ))
}
