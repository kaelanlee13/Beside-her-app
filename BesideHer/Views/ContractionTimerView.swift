//
//  ContractionTimerView.swift
//  BesideHer
//
//  Tracks contraction duration and frequency during labor
//

import SwiftUI
import Combine

// MARK: - Models

private struct ContractionRecord: Identifiable {
    let id = UUID()
    let number: Int
    let startTime: Date
    let duration: TimeInterval
    let interval: TimeInterval? // start-to-start from previous contraction
}

private enum ContractionState {
    case idle
    case active(startedAt: Date)
    case between(lastEnd: Date, lastDuration: TimeInterval, lastStart: Date)
}

// MARK: - View

struct ContractionTimerView: View {
    @State private var state: ContractionState = .idle
    @State private var records: [ContractionRecord] = []
    @State private var elapsedSeconds: Int = 0
    @State private var restSeconds: Int = 0
    @State private var isPulsing: Bool = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                mainDisplayCard
                actionButton
                if !records.isEmpty {
                    statsCard
                    historyCard
                }
                ruleCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color(hex: "F7F9FC"))
        .navigationTitle("Contraction Timer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !records.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") { reset() }
                        .foregroundColor(Color(hex: "FF6B6B"))
                }
            }
        }
        .onReceive(ticker) { _ in tick() }
    }

    // MARK: - Main Display Card

    private var mainDisplayCard: some View {
        Group {
            switch state {
            case .idle:
                idleDisplay
            case .active:
                activeDisplay
            case .between(_, let lastDuration, _):
                betweenDisplay(lastDuration: lastDuration)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
        )
    }

    private var idleDisplay: some View {
        VStack(spacing: 12) {
            Image(systemName: "timer")
                .font(.system(size: 52))
                .foregroundColor(Color(hex: "3B7DD8").opacity(0.25))
            Text("Ready to track")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "1A2B42"))
            Text("Tap the button when a\ncontraction begins")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
    }

    private var activeDisplay: some View {
        VStack(spacing: 8) {
            Text("CONTRACTION IN PROGRESS")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "FF6B6B"))
                .tracking(1.2)

            Text(formatTime(elapsedSeconds))
                .font(.system(size: 68, weight: .bold, design: .monospaced))
                .foregroundColor(Color(hex: "FF6B6B"))
                .scaleEffect(isPulsing ? 1.04 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear { isPulsing = true }
                .onDisappear { isPulsing = false }

            if let last = records.last {
                Text("Last contraction: \(formatTime(Int(last.duration)))")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8E9BAD"))
            }
        }
        .padding(.vertical, 8)
    }

    private func betweenDisplay(lastDuration: TimeInterval) -> some View {
        VStack(spacing: 20) {
            Text("REST PERIOD")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "8E9BAD"))
                .tracking(1.2)

            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text(formatTime(Int(lastDuration)))
                        .font(.system(size: 38, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "56B89F"))
                    Text("last duration")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8E9BAD"))
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 1, height: 56)

                VStack(spacing: 4) {
                    Text(formatTime(restSeconds))
                        .font(.system(size: 38, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "3B7DD8"))
                    Text("resting")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8E9BAD"))
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
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(buttonColor)
                        .shadow(color: buttonColor.opacity(0.35), radius: 8, y: 4)
                )
        }
    }

    private var buttonLabel: String {
        switch state {
        case .idle:    return "Start Contraction"
        case .active:  return "Stop Contraction"
        case .between: return "Start Next Contraction"
        }
    }

    private var buttonColor: Color {
        if case .active = state { return Color(hex: "FF6B6B") }
        return Color(hex: "3B7DD8")
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        HStack(spacing: 0) {
            statItem(value: "\(records.count)", label: "Contractions")
            Divider().frame(height: 44)
            statItem(value: avgDuration, label: "Avg Duration")
            Divider().frame(height: 44)
            statItem(value: avgInterval, label: "Avg Interval")
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
        )
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "8E9BAD"))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - History Card

    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))

            ForEach(records.reversed()) { record in
                HStack {
                    Text("#\(record.number)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "8E9BAD"))
                        .frame(width: 28, alignment: .leading)

                    Text(formatTime(Int(record.duration)))
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color(hex: "56B89F"))

                    Spacer()

                    if let interval = record.interval {
                        Text("every \(formatTime(Int(interval)))")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "8E9BAD"))
                    } else {
                        Text("first")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "8E9BAD"))
                    }
                }

                if record.id != records.first?.id {
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
    }

    // MARK: - 5-1-1 Rule Card

    private var ruleCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(Color(hex: "3B7DD8"))
                .font(.system(size: 14))
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 4) {
                Text("The 5-1-1 Rule")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "3B7DD8"))
                Text("Head to the hospital when contractions are 5 minutes apart, last at least 1 minute each, for 1 hour.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "5A6B80"))
                    .lineSpacing(3)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "E8F0FE"))
        )
    }

    // MARK: - Logic

    private func handleTap() {
        let now = Date()
        switch state {
        case .idle:
            state = .active(startedAt: now)
            elapsedSeconds = 0

        case .active(let startedAt):
            let duration = now.timeIntervalSince(startedAt)
            let interval = records.last.map { startedAt.timeIntervalSince($0.startTime) }
            let record = ContractionRecord(
                number: records.count + 1,
                startTime: startedAt,
                duration: duration,
                interval: interval
            )
            records.append(record)
            state = .between(lastEnd: now, lastDuration: duration, lastStart: startedAt)
            elapsedSeconds = 0
            restSeconds = 0

        case .between:
            state = .active(startedAt: now)
            elapsedSeconds = 0
            restSeconds = 0
        }
    }

    private func tick() {
        switch state {
        case .idle:
            break
        case .active(let startedAt):
            elapsedSeconds = Int(Date().timeIntervalSince(startedAt))
        case .between(let lastEnd, _, _):
            restSeconds = Int(Date().timeIntervalSince(lastEnd))
        }
    }

    private func reset() {
        state = .idle
        records = []
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
        guard !records.isEmpty else { return "—" }
        let avg = records.map(\.duration).reduce(0, +) / Double(records.count)
        return formatTime(Int(avg))
    }

    private var avgInterval: String {
        let intervals = records.compactMap(\.interval)
        guard !intervals.isEmpty else { return "—" }
        let avg = intervals.reduce(0, +) / Double(intervals.count)
        return formatTime(Int(avg))
    }
}

#Preview {
    NavigationStack {
        ContractionTimerView()
    }
}
