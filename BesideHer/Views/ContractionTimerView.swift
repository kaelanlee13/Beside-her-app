//
//  ContractionTimerView.swift
//  BesideHer
//
//  Tracks contraction duration and frequency during labor.
//
//  History and in-progress timer are persisted via SwiftData (ContractionRecord),
//  so closing or killing the app — even mid-contraction — preserves all data.
//

import SwiftUI
import SwiftData
import Combine

// MARK: - View

struct ContractionTimerView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ContractionRecord.startTime, order: .forward)
    private var records: [ContractionRecord]

    @State private var elapsedSeconds: Int = 0
    @State private var restSeconds: Int = 0
    @State private var isPulsing: Bool = false
    @State private var timerStarted: Bool = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Derived state

    private enum DisplayState {
        case idle
        case active(startedAt: Date)
        case between(lastEnd: Date, lastDuration: TimeInterval)
    }

    private var liveRecord: ContractionRecord? {
        records.last(where: { $0.isActive })
    }

    private var completedRecords: [ContractionRecord] {
        records.filter { !$0.isActive }
    }

    private var displayState: DisplayState {
        if let liveRecord {
            return .active(startedAt: liveRecord.startTime)
        }
        if let last = completedRecords.last,
           let endTime = last.endTime,
           let duration = last.duration {
            return .between(lastEnd: endTime, lastDuration: duration)
        }
        return .idle
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                mainDisplayCard
                actionButton
                if !completedRecords.isEmpty {
                    statsCard
                    historyCard
                }
                ruleCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.paper)
        .navigationTitle("Contraction Timer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !records.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") { reset() }
                        .foregroundColor(Color.alert)
                }
            }
        }
        .onAppear { tick() }
        .onReceive(ticker) { _ in tick() }
    }

    // MARK: - Main Display Card

    private var mainDisplayCard: some View {
        Group {
            switch displayState {
            case .idle:
                idleDisplay
            case .active:
                activeDisplay
            case .between(_, let lastDuration):
                betweenDisplay(lastDuration: lastDuration)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.surface)
                .premiumShadow()
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(Color.divider, lineWidth: 1)
        )
    }

    private var idleDisplay: some View {
        VStack(spacing: 12) {
            Image(systemName: "timer")
                .font(.system(size: 52))
                .foregroundStyle(Color.accent.opacity(0.3))
            Text("Ready to track")
                .font(.h2)
                .foregroundStyle(Color.ink)
            Text("Tap the button when a\ncontraction begins")
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
    }

    private var activeDisplay: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.alert)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isPulsing ? 1.4 : 1.0)
                    .opacity(isPulsing ? 0.6 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)

                Text("CONTRACTION IN PROGRESS")
                    .font(.eyebrow)
                    .textCase(.uppercase)
                    .tracking(1.4)
                    .foregroundStyle(Color.alert)
            }

            Text(formatTime(elapsedSeconds))
                .font(.timerNumeral)
                .foregroundStyle(Color.alert)
                .scaleEffect(isPulsing ? 1.04 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear { isPulsing = true }
                .onDisappear { isPulsing = false }

            if let last = completedRecords.last, let duration = last.duration {
                Text("Last contraction: \(formatTime(Int(duration)))")
                    .font(.captionText)
                    .foregroundStyle(Color.inkSecondary)
            }
        }
        .padding(.vertical, 8)
    }

    private func betweenDisplay(lastDuration: TimeInterval) -> some View {
        VStack(spacing: 20) {
            Text("REST PERIOD")
                .eyebrowStyle()

            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text(formatTime(Int(lastDuration)))
                        .font(.system(size: 38, weight: .light, design: .serif).monospacedDigit())
                        .foregroundStyle(Color.sage)
                    Text("last duration")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color.divider)
                    .frame(width: 1, height: 56)

                VStack(spacing: 4) {
                    Text(formatTime(restSeconds))
                        .font(.system(size: 38, weight: .light, design: .serif).monospacedDigit())
                        .foregroundStyle(Color.ink)
                    Text("resting")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Action Button

    private var actionButton: some View {
        Button(action: handleTap) {
            Text(buttonLabel)
                .font(.bodyText.weight(.bold))
                .foregroundStyle(Color.onAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: Radius.card)
                        .fill(buttonColor)
                        .premiumShadow()
                )
        }
        .sensoryFeedback(.impact(weight: .light), trigger: timerStarted)
    }

    private var buttonLabel: String {
        switch displayState {
        case .idle:    return "Start Contraction"
        case .active:  return "Stop Contraction"
        case .between: return "Start Next Contraction"
        }
    }

    private var buttonColor: Color {
        if case .active = displayState { return Color.alert }
        return Color.accent
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        HStack(spacing: 0) {
            statItem(value: "\(completedRecords.count)", label: "Contractions")
            Divider().frame(height: 44)
            statItem(value: avgDuration, label: "Avg Duration")
            Divider().frame(height: 44)
            statItem(value: avgInterval, label: "Avg Interval")
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.surface)
                .premiumShadow()
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(Color.divider, lineWidth: 1)
        )
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.h2)
                .foregroundStyle(Color.ink)
            Text(label)
                .font(.captionText)
                .foregroundStyle(Color.inkSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - History Card

    private var historyCard: some View {
        let rows = historyRows
        return VStack(alignment: .leading, spacing: 12) {
            Text("CONTRACTION LOG")
                .eyebrowStyle()

            Text("History")
                .font(.h2)
                .foregroundStyle(Color.ink)

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                HStack {
                    Text("#\(row.number)")
                        .font(.captionText.weight(.semibold))
                        .foregroundStyle(Color.inkSecondary)
                        .frame(width: 28, alignment: .leading)

                    Text(formatTime(Int(row.duration)))
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Color.ink)

                    Spacer()

                    if let interval = row.interval {
                        Text("every \(formatTime(Int(interval)))")
                            .font(.captionText)
                            .foregroundStyle(Color.inkSecondary)
                    } else {
                        Text("first")
                            .font(.captionText)
                            .foregroundStyle(Color.inkSecondary)
                    }
                }

                if index < rows.count - 1 {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.surface)
                .premiumShadow()
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(Color.divider, lineWidth: 1)
        )
    }

    private struct HistoryRow {
        let id: PersistentIdentifier
        let number: Int
        let duration: TimeInterval
        let interval: TimeInterval?
    }

    /// Numbers contractions chronologically, computes intervals between
    /// successive starts, then reverses for newest-first display.
    private var historyRows: [HistoryRow] {
        let chronological = completedRecords
        var rows: [HistoryRow] = []
        rows.reserveCapacity(chronological.count)
        for (index, record) in chronological.enumerated() {
            let interval: TimeInterval? = index > 0
                ? record.startTime.timeIntervalSince(chronological[index - 1].startTime)
                : nil
            rows.append(HistoryRow(
                id: record.persistentModelID,
                number: index + 1,
                duration: record.duration ?? 0,
                interval: interval
            ))
        }
        return rows.reversed()
    }

    // MARK: - 5-1-1 Rule Card

    private var ruleCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(Color.accent)
                .font(.system(size: 14))
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 4) {
                Text("WHEN TO GO")
                    .eyebrowStyle()
                Text("The 5-1-1 Rule")
                    .font(.h2)
                    .foregroundStyle(Color.ink)
                Text("Head to the hospital when contractions are 5 minutes apart, last at least 1 minute each, for 1 hour.")
                    .font(.captionText)
                    .foregroundStyle(Color.inkSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Radius.card)
                .fill(Color.accentSoft)
        )
    }

    // MARK: - Logic

    private func handleTap() {
        let now = Date()
        if let liveRecord {
            // End the active contraction.
            liveRecord.endTime = now
            elapsedSeconds = 0
            restSeconds = 0
        } else {
            // Start a new contraction (works from idle or between).
            let new = ContractionRecord(startTime: now)
            modelContext.insert(new)
            elapsedSeconds = 0
            restSeconds = 0
            timerStarted.toggle()
        }
    }

    private func tick() {
        switch displayState {
        case .idle:
            break
        case .active(let startedAt):
            elapsedSeconds = Int(Date().timeIntervalSince(startedAt))
        case .between(let lastEnd, _):
            restSeconds = Int(Date().timeIntervalSince(lastEnd))
        }
    }

    private func reset() {
        for record in records {
            modelContext.delete(record)
        }
        elapsedSeconds = 0
        restSeconds = 0
        isPulsing = false
    }

    // MARK: - Helpers

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private var avgDuration: String {
        let durations = completedRecords.compactMap(\.duration)
        guard !durations.isEmpty else { return "—" }
        let avg = durations.reduce(0, +) / Double(durations.count)
        return formatTime(Int(avg))
    }

    private var avgInterval: String {
        let chronological = completedRecords
        guard chronological.count > 1 else { return "—" }
        var intervals: [TimeInterval] = []
        for i in 1..<chronological.count {
            intervals.append(chronological[i].startTime.timeIntervalSince(chronological[i - 1].startTime))
        }
        guard !intervals.isEmpty else { return "—" }
        let avg = intervals.reduce(0, +) / Double(intervals.count)
        return formatTime(Int(avg))
    }
}

#Preview {
    NavigationStack {
        ContractionTimerView()
    }
    .modelContainer(for: ContractionRecord.self, inMemory: true)
}
