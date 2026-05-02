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
            ZStack(alignment: .topTrailing) {
                // Background gradient
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.heroGradient)

                VStack(alignment: .leading, spacing: 0) {

                    // Top row: greeting + gear
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Good \(greeting)")
                                .font(AppTheme.captionFont)
                                .foregroundColor(.white.opacity(0.65))
                            Text("Week \(profile.currentWeek)")
                                .font(AppTheme.serifHero(size: 56))
                                .foregroundColor(.white)
                                .lineSpacing(0)
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView(profile: profile)) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.12))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "gearshape")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                        }
                        // Prevent gear tap from triggering the outer NavigationLink
                        .simultaneousGesture(TapGesture())
                    }

                    // Baby size
                    if let week = currentWeekContent {
                        Text("\(week.sizeEmoji)  \(babyLabel) is the size of \(articleFor(week.sizeComparison)) \(week.sizeComparison.lowercased())")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 14)
                    }

                    // Countdown pill + CTA row
                    HStack {
                        Text(countdownText)
                            .font(AppTheme.labelFont)
                            .foregroundColor(AppTheme.accent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppTheme.accent.opacity(0.15))
                            .clipShape(Capsule())

                        Spacer()

                        HStack(spacing: 4) {
                            Text("Week guide")
                                .font(AppTheme.labelFont)
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(20)
            }
            .shadow(color: AppTheme.deepNavy.opacity(0.3), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
        // Only navigate when currentWeekContent exists
        .disabled(currentWeekContent == nil)
    }


    // MARK: - Progress Card

    private var progressCard: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Pregnancy Progress")
                    .font(AppTheme.captionFont.weight(.semibold))
                    .foregroundColor(AppTheme.textSecondary)
                Spacer()
                Text("\(Int(profile.progressPercentage * 100))%")
                    .font(AppTheme.captionFont.weight(.bold))
                    .foregroundColor(AppTheme.primary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppTheme.softBlue.opacity(0.25))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppTheme.primaryGradient)
                        .frame(width: geo.size.width * profile.progressPercentage, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Week 1")
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.textTertiary)
                Spacer()
                Text("Week 40")
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.textTertiary)
            }
        }
        .padding(16)
        .background(whiteCard)
    }

    // MARK: - Contraction Timer Row

    private var contractionRow: some View {
        NavigationLink(destination: ContractionTimerView()) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.primary.opacity(0.1))
                        .frame(width: 42, height: 42)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.primary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Contraction Timer")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("Track contractions during labor")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textTertiary)
            }
            .padding(16)
            .background(whiteCard)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tasks Card

    private func tasksCard(week: Week) -> some View {
        let checklistItems = weekChecklistItems
        let totalCount = week.actionItems.count + checklistItems.count
        let completedCount = week.actionItems.filter { profile.isActionItemCompleted($0.id) }.count
            + checklistItems.filter { profile.isChecklistItemCompleted($0.id) }.count

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Week's Tasks")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("\(completedCount) of \(totalCount)")
                    .font(AppTheme.captionFont.weight(.semibold))
                    .foregroundColor(AppTheme.primary)
            }

            ForEach(week.actionItems) { item in
                taskRow(
                    text: item.text,
                    isCompleted: profile.isActionItemCompleted(item.id),
                    onToggle: { profile.toggleActionItem(item.id) }
                )
            }

            ForEach(checklistItems) { item in
                taskRow(
                    text: item.text,
                    isCompleted: profile.isChecklistItemCompleted(item.id),
                    onToggle: { profile.toggleChecklistItem(item.id) }
                )
            }
        }
        .padding(16)
        .background(whiteCard)
    }

    private func taskRow(text: String, isCompleted: Bool, onToggle: @escaping () -> Void) -> some View {
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
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(isCompleted ? AppTheme.textTertiary : AppTheme.textPrimary)
                .strikethrough(isCompleted, color: AppTheme.textTertiary)
        }
    }

    // MARK: - Dad Question Card

    private func dadQuestionCard(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.primary)
                Text("Common Dad Question")
                    .font(AppTheme.captionFont.weight(.semibold))
                    .foregroundColor(AppTheme.primary)
            }
            Text(question)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            Text(answer)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(whiteCard)
    }

    // MARK: - Shared Helpers

    private var whiteCard: some View {
        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
            .fill(Color.surface)
            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "morning"
        case 12..<17: return "afternoon"
        default:     return "evening"
        }
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
