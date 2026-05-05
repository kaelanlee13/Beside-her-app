//
//  NotificationView.swift
//  BesideHer
//
//  Onboarding Step 3: Notification permission request
//

import SwiftUI

struct NotificationView: View {
    var onEnable: () -> Void
    var onSkip: () -> Void
    var onBack: () -> Void

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

            ZStack {
                Circle()
                    .fill(Color.accentSoft)
                    .frame(width: 72, height: 72)
                Image(systemName: "bell.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.accent)
            }
            .padding(.bottom, 20)

            Text("Stay in the loop")
                .font(.h1)
                .foregroundStyle(Color.ink)

            Text("Get a weekly reminder when new\ncontent unlocks for your\ncurrent week.")
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                benefitRow(icon: "calendar.badge.clock", text: "Weekly updates matched to your timeline")
                benefitRow(icon: "checklist", text: "Reminders for upcoming tasks")
                benefitRow(icon: "lightbulb", text: "Tips right when you need them")
            }
            .padding(.top, 32)
            .padding(.horizontal, 40)

            Spacer()

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.accent)
                    .frame(width: 24, height: 4)
            }
            .padding(.bottom, 32)

            Button(action: onEnable) {
                Text("Enable Notifications")
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

            Button(action: onSkip) {
                Text("Maybe later")
                    .font(.bodyText.weight(.medium))
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }

    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.accent)
                .frame(width: 24)
            Text(text)
                .font(.bodyText)
                .foregroundStyle(Color.ink)
        }
    }
}

#Preview {
    NotificationView(
        onEnable: {},
        onSkip: {},
        onBack: {}
    )
}
