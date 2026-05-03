//
//  ChecklistRow.swift
//  BesideHer
//

import SwiftUI

/// Minimal editorial row for checklist and task items.
/// No card, no background — just text and a circle.
/// Parent is responsible for placing rows inside a container
/// and deciding whether to show the trailing hairline divider.
struct ChecklistRow: View {
    let title: String
    var description: String? = nil
    var category: String? = nil
    let isComplete: Bool
    let onToggle: () -> Void
    var showDivider: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    onToggle()
                }
            }) {
                HStack(alignment: .top, spacing: 12) {
                    // 22pt circle checkbox
                    ZStack {
                        Circle()
                            .strokeBorder(isComplete ? Color.clear : Color.divider, lineWidth: 1)
                        Circle()
                            .fill(isComplete ? Color.accent : .clear)
                        if isComplete {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Color.onAccent)
                                .symbolEffect(.bounce, value: isComplete)
                        }
                    }
                    .frame(width: 22, height: 22)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isComplete)

                    // Text stack
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.bodyText)
                            .foregroundStyle(Color.ink)
                            .opacity(isComplete ? 0.35 : 1.0)
                            .strikethrough(isComplete, color: Color.inkSecondary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let description {
                            Text(description)
                                .font(.captionText)
                                .foregroundStyle(Color.inkSecondary)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }

                        if let category {
                            Text(category)
                                .eyebrowStyle()
                        }
                    }
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if showDivider {
                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)
            }
        }
        .sensoryFeedback(.success, trigger: isComplete) { _, newValue in newValue }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        ChecklistRow(
            title: "Schedule hospital tour and pre-registration",
            description: "Most hospitals offer tours in the third trimester.",
            category: "Appointments",
            isComplete: false,
            onToggle: {}
        )
        ChecklistRow(
            title: "Pack the hospital bag",
            description: nil,
            category: nil,
            isComplete: true,
            onToggle: {},
            showDivider: false
        )
    }
    .padding(.horizontal, 20)
    .background(Color.paper)
}
