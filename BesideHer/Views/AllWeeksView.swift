//
//  AllWeeksView.swift
//  BesideHer
//

import SwiftUI

struct AllWeeksView: View {
    let profile: UserProfile
    let content = ContentService.shared

    private let trimesters: [TrimesterSection] = [
        TrimesterSection(number: 1, label: "FIRST TRIMESTER · WEEKS 1–13",  range: 1...13),
        TrimesterSection(number: 2, label: "SECOND TRIMESTER · WEEKS 14–27", range: 14...27),
        TrimesterSection(number: 3, label: "THIRD TRIMESTER · WEEKS 28–40",  range: 28...40),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xxl) {
                    masthead

                    ForEach(trimesters) { section in
                        trimesterSection(section)
                    }
                }
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.paper.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Masthead

    private var masthead: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("GUIDE").eyebrowStyle()
            Text("Forty Weeks")
                .font(.h1)
                .foregroundStyle(Color.ink)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Trimester section

    @ViewBuilder
    private func trimesterSection(_ section: TrimesterSection) -> some View {
        let weeksInRange = content.weeks.filter { section.range.contains($0.weekNumber) }
        let currentWeekHere = section.range.contains(profile.currentWeek)
            ? content.weeks.first(where: { $0.weekNumber == profile.currentWeek })
            : nil
        let otherWeeks = weeksInRange.filter { $0.weekNumber != profile.currentWeek }

        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(section.label)
                .eyebrowStyle()
                .padding(.horizontal, 20)

            if let current = currentWeekHere {
                currentWeekHero(week: current)
                    .padding(.horizontal, 20)
            }

            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(otherWeeks.enumerated()), id: \.element.id) { idx, week in
                    weekRow(week)
                    if idx < otherWeeks.count - 1 {
                        Rectangle()
                            .fill(Color.divider)
                            .frame(height: 1)
                            .padding(.leading, Spacing.lg + 40 + Spacing.lg)
                            .padding(.trailing, Spacing.lg)
                    }
                }
            }
        }
    }

    // MARK: - Current week hero card (matches Home hero)

    private func currentWeekHero(week: Week) -> some View {
        NavigationLink(destination: WeekDetailView(week: week, profile: profile)) {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack(alignment: .top, spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("WEEK \(week.weekNumber) OF 40").eyebrowStyle()
                        Text(week.title)
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

                Text("Size of \(articleFor(week.sizeComparison)) \(week.sizeComparison.lowercased())")
                    .font(.bodyText)
                    .foregroundStyle(Color.inkSecondary)
                    .lineLimit(2)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.divider).frame(height: 1)
                        Rectangle()
                            .fill(Color.accent)
                            .frame(width: geo.size.width * min(profile.progressPercentage, 1.0), height: 1)
                            .animation(.easeInOut(duration: 0.4), value: profile.progressPercentage)
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
    }

    // MARK: - Magazine TOC row

    private func weekRow(_ week: Week) -> some View {
        let isPast = week.weekNumber < profile.currentWeek
        return NavigationLink(destination: WeekDetailView(week: week, profile: profile)) {
            HStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.surface)
                        .frame(width: 40, height: 40)
                        .overlay(Circle().strokeBorder(Color.divider, lineWidth: 1))
                    Image(systemName: "leaf")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.inkSecondary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Week \(week.weekNumber)")
                        .font(.h2)
                        .fontDesign(.serif)
                        .foregroundStyle(Color.ink)
                    Text(week.title)
                        .font(.bodyText)
                        .foregroundStyle(Color.ink)
                        .lineLimit(1)
                    Text("Size of \(articleFor(week.sizeComparison)) \(week.sizeComparison.lowercased())")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressable)
        .opacity(isPast ? 0.55 : 1.0)
    }

    // MARK: - Helpers

    private func articleFor(_ word: String) -> String {
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        if let first = word.lowercased().first, vowels.contains(first) { return "an" }
        return "a"
    }
}

private struct TrimesterSection: Identifiable {
    let number: Int
    let label: String
    let range: ClosedRange<Int>
    var id: Int { number }
}

#Preview {
    AllWeeksView(profile: UserProfile(
        dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
        onboardingCompleted: true
    ))
}
