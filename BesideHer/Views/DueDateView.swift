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
        let upper = Calendar.current.date(byAdding: .month, value: 10, to: now)!
        return now...upper
    }()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "3B7DD8"))
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()

            // Step label
            Text("STEP 2 OF 4")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "3B7DD8"))
                .tracking(1)
                .padding(.bottom, 8)

            // Title
            Text("When is the\ndue date?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
                .multilineTextAlignment(.center)

            // Description
            Text("We'll calculate which week you're in\nand personalize your content.")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 24)

            // Custom calendar picker
            CalendarGridView(selectedDate: $dueDate, validRange: Self.validRange)
                .padding(.horizontal, 24)

            Spacer()

            // Page indicator
            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "3B7DD8"))
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
            }
            .padding(.bottom, 32)

            // Continue button
            Button(action: onContinue) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "3B7DD8"))
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
        self._displayedMonth = State(initialValue: Calendar.current.date(from: comps)!)
    }

    var body: some View {
        VStack(spacing: 12) {
            monthHeader
            weekdayHeader
            dayGrid
        }
    }

    // MARK: Month navigation header

    private var monthHeader: some View {
        HStack {
            Button(action: goToPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(canGoPrevious ? Color(hex: "3B7DD8") : Color(hex: "E4EAF1"))
            }
            .disabled(!canGoPrevious)

            Spacer()

            Text(monthYearString)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color(hex: "1A2B42"))

            Spacer()

            Button(action: goToNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(canGoNext ? Color(hex: "3B7DD8") : Color(hex: "E4EAF1"))
            }
            .disabled(!canGoNext)
        }
        .padding(.horizontal, 8)
    }

    // MARK: Weekday label row

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdayLabels, id: \.self) { label in
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "5A6B80"))
                    .frame(width: 40, height: 24)
            }
        }
    }

    // MARK: Day cells — always 6 rows so height never changes

    private var dayGrid: some View {
        // Fixed spacing of 4 between rows regardless of selection state
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
                            // Empty placeholder — same fixed frame keeps columns aligned
                            Color.clear.frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }

    // MARK: Helpers

    private var monthYearString: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    /// Always returns exactly 6 rows (42 cells) so the grid height is constant.
    private var weeks: [[Date?]] {
        guard let interval = calendar.dateInterval(of: .month, for: displayedMonth) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: interval.start) - 1

        var cells: [Date?] = Array(repeating: nil, count: firstWeekday)
        var cursor = interval.start
        while cursor < interval.end {
            cells.append(cursor)
            cursor = calendar.date(byAdding: .day, value: 1, to: cursor)!
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
                .foregroundColor(labelColor)
                // Fixed frame so the circle highlight never shifts surrounding cells
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? Color(hex: "3B7DD8") : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var labelColor: Color {
        if isSelected { return .white }
        if !isEnabled { return Color(hex: "5A6B80").opacity(0.3) }
        return Color(hex: "1A2B42")
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
