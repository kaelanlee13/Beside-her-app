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

                    // ─── Hero Card ───────────────────────────────────────────
                    heroCard
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    // ─── Progress ───────────────────────────────────────────
                    progressCard
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                    // ─── Contraction Timer CTA ──────────────────────────────
                    contractionRow
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    // ─── This Week's Tasks ──────────────────────────────────
                    if let week = currentWeekContent {
                        tasksCard(week: week)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
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

    // MARK: - Hero Card

    private var heroCard: some View {
        NavigationLink(destination: Group {
            if let week = currentWeekContent {
                WeekDetailView(week: week, profile: profile)
            }
        }) {
            VStack(alignment: .leading, spacing: Spacing.lg) {

                // Top section: text + illustration
                HStack(alignment: .top, spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("WEEK \(profile.currentWeek) OF 40")
                            .eyebrowStyle()
                            .contentTransition(.numericText())
                            .animation(.easeInOut(duration: 0.6), value: profile.currentWeek)

                        Text(heroHeadlineText)
                            .font(.hero)
                            .foregroundStyle(Color.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: Spacing.sm)

                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Color.accent.opacity(0.18))
                }

                if let week = currentWeekContent {
                    Text(heroBodyText(week))
                        .font(.bodyText)
                        .foregroundStyle(Color.inkSecondary)
                        .lineLimit(2)
                }

                // Progress ruler — full-width, no label
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
        return "\(subject) the size of \(articleFor(week.sizeComparison)) \(week.sizeComparison.lowercased())."
    }

    private func heroBodyText(_ week: Week) -> String {
        "\(week.title)  ·  \(countdownText)"
    }


    // MARK: - Progress Card

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("PROGRESS")
                .eyebrowStyle()

            Text(progressHeadlineText)
                .font(.h1)
                .foregroundStyle(Color.ink)

            HairlineProgressRuler(
                progress: profile.progressPercentage,
                ticks: [13.0 / 40.0, 27.0 / 40.0]
            )
            .padding(.vertical, Spacing.xs)

            Text("Week \(profile.currentWeek) of 40")
                .font(.captionText)
                .foregroundStyle(Color.inkSecondary)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.6), value: profile.currentWeek)
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.surface)
                .premiumShadow()
        )
    }

    private var progressHeadlineText: String {
        let cal = Calendar.current
        let days = cal.dateComponents([.day], from: cal.startOfDay(for: Date()),
                                      to: cal.startOfDay(for: profile.dueDate)).day ?? 0
        switch days {
        case ..<0:  return "Baby may have arrived"
        case 0:     return "Due today"
        case 1:     return "1 day to go"
        case 2..<14: return "\(days) days to go"
        default:
            let weeks = (days + 6) / 7
            return "\(weeks) week\(weeks == 1 ? "" : "s") to go"
        }
    }

    // MARK: - Contraction Timer Row

    private var contractionRow: some View {
        NavigationLink(destination: ContractionTimerView()) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.input)
                        .fill(Color.divider)
                        .frame(width: 42, height: 42)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.inkSecondary)
                }
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
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 14))
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
        .padding(16)
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

    private var countdownText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due   = calendar.startOfDay(for: profile.dueDate)
        let days  = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        switch days {
        case ..<0: return "Overdue by \(abs(days))d"
        case 0:    return "Due today!"
        case 1:    return "1 day to go"
        default:   return "\(days) days to go"
        }
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


#Preview {
    HomeView(profile: UserProfile(
        dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
        onboardingCompleted: true
    ))
}
