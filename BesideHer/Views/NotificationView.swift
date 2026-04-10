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
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "E8F0FE"))
                    .frame(width: 72, height: 72)
                
                Text("🔔")
                    .font(.system(size: 32))
            }
            .padding(.bottom, 20)
            
            // Title
            Text("Stay in the loop")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
            
            // Description
            Text("Get a weekly reminder when new\ncontent unlocks for your\ncurrent week.")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
            
            // Benefits
            VStack(alignment: .leading, spacing: 12) {
                benefitRow(icon: "calendar.badge.clock", text: "Weekly updates matched to your timeline")
                benefitRow(icon: "checklist", text: "Reminders for upcoming tasks")
                benefitRow(icon: "lightbulb", text: "Tips right when you need them")
            }
            .padding(.top, 32)
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Page indicator
            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "3B7DD8"))
                    .frame(width: 24, height: 4)
            }
            .padding(.bottom, 32)
            
            // Enable button
            Button(action: onEnable) {
                Text("Enable Notifications")
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
            
            // Skip button
            Button(action: onSkip) {
                Text("Maybe later")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "5A6B80"))
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "3B7DD8"))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "1A2B42"))
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
