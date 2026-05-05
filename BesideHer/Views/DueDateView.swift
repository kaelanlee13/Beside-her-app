//
//  DueDateView.swift
//  BesideHer
//
//  Onboarding Step 2: Due date picker
//

import SwiftUI

struct DueDateView: View {
    @Binding var dueDate: Date
    var onContinue: () -> Void
    var onBack: () -> Void

    private static let validRange: ClosedRange<Date> = {
        let now = Date()
        let upper = Calendar.current.date(byAdding: .month, value: 10, to: now) ?? now
        return now...upper
    }()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.bodyText.weight(.semibold))
                    }
                    .foregroundStyle(Color.accent)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()

            Text("STEP 2 OF 4")
                .font(.eyebrow)
                .textCase(.uppercase)
                .tracking(1.4)
                .foregroundStyle(Color.accent)
                .padding(.bottom, 8)

            Text("When is the\ndue date?")
                .font(.h1)
                .foregroundStyle(Color.ink)
                .multilineTextAlignment(.center)

            Text("We'll calculate which week you're in\nand personalize your content.")
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 24)

            CalendarGridView(selectedDate: $dueDate, validRange: Self.validRange)
                .padding(.horizontal, 24)

            Spacer()

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.accent)
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
            }
            .padding(.bottom, 32)

            Button(action: onContinue) {
                Text("Continue")
                    .font(.bodyText.weight(.semibold))
                    .foregroundStyle(Color.onAccent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .fill(Color.accent)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Calendar grid

private struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let validRange: ClosedRange<Date>

    @State private var displayedMonth: Date

    private let calendar = Calendar.current
    private let weekdayLabels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    init(selectedDate: Binding<Date>, validRange: ClosedRange<Date>) {
        self._selectedDate = selectedDate
        self.validRange = validRange
        let comps = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
        let monthStart = Calendar.current.date(from: comps) ?? selectedDate.wrappedValue
        self._displayedMonth = State(initialValue: monthStart)
    }

    var body: some View {
        VStack(spacing: 12) {
            monthHeader
            weekdayHeader
            dayGrid
        }
    }

    private var monthHeader: some View {
        HStack {
            Button(action: goToPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(canGoPrevious ? Color.accent : Color.divider)
            }
            .disabled(!canGoPrevious)

            Spacer()

            Text(monthYearString)
                .font(.h2)
                .foregroundStyle(Color.ink)

            Spacer()

            Button(action: goToNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(canGoNext ? Color.accent : Color.divider)
            }
            .disabled(!canGoNext)
        }
        .padding(.horizontal, 8)
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdayLabels, id: \.self) { label in
                Text(label)
                    .font(.captionText.weight(.medium))
                    .foregroundStyle(Color.inkSecondary)
                    .frame(width: 40, height: 24)
            }
        }
    }

    private var dayGrid: some View {
        VStack(spacing: 4) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { col in
                        if let date = week[col] {
                            DayCellView(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isEnabled: validRange.contains(startOfDay(date))
                            ) {
                                selectedDate = date
                            }
                        } else {
                            Color.clear.frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }

    private var monthYearString: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    private var weeks: [[Date?]] {
        guard let interval = calendar.dateInterval(of: .month, for: displayedMonth) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: interval.start) - 1

        var cells: [Date?] = Array(repeating: nil, count: firstWeekday)
        var cursor = interval.start
        while cursor < interval.end {
            cells.append(cursor)
            guard let next = calendar.date(byAdding: .day, value: 1, to: cursor) else { break }
            cursor = next
        }
        while cells.count < 42 { cells.append(nil) }

        return stride(from: 0, to: 42, by: 7).map { Array(cells[$0..<$0 + 7]) }
    }

    private var canGoPrevious: Bool {
        guard let prev = calendar.date(byAdding: .month, value: -1, to: displayedMonth),
              let lastOfPrev = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: prev)
        else { return false }
        return lastOfPrev >= startOfDay(validRange.lowerBound)
    }

    private var canGoNext: Bool {
        guard let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return false }
        return next <= validRange.upperBound
    }

    private func goToPreviousMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = prev
        }
    }

    private func goToNextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = next
        }
    }

    private func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}

// MARK: - Individual day cell

private struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        Button(action: action) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(labelColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? Color.accent : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var labelColor: Color {
        if isSelected { return Color.onAccent }
        if !isEnabled { return Color.inkSecondary.opacity(0.3) }
        return Color.ink
    }
}

// MARK: - Preview

#Preview {
    DueDateView(
        dueDate: .constant(Date()),
        onContinue: {},
        onBack: {}
    )
}
