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

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // 22pt circle checkbox — tap toggles completion
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        onToggle()
                    }
                }) {
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
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                // Text stack — tap toggles description expansion
                Button(action: {
                    guard description != nil else { return }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        isExpanded.toggle()
                    }
                }) {
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
                                .lineLimit(isExpanded ? nil : 3)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if let category {
                            Text(category)
                                .eyebrowStyle()
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 12)

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
