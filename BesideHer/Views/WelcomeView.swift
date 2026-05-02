//
//  WelcomeView.swift
//  BesideHer
//
//  Onboarding Step 1: Welcome screen
//

import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 10) {
                Text("besideher")
                    .font(Font.custom("Georgia", size: 46))
                    .foregroundColor(Color(hex: "3A6F8F"))
                    .tracking(1.3)
                Text("BESIDE HER THROUGH IT ALL")
                    .font(.eyebrow)
                    .textCase(.uppercase)
                    .tracking(3.2)
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.bottom, 24)

            Text("Your week-by-week guide to\nsupporting your partner\nthrough pregnancy")
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 8)

            Spacer()

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color.accent)
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
            }
            .padding(.bottom, 32)

            Button(action: onContinue) {
                Text("Get Started")
                    .font(.bodyText.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.accent)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
