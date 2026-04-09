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
            
            // Logo
            VStack(spacing: 10) {
                Text("besideher")
                    .font(Font.custom("Georgia", size: 46))
                    .foregroundColor(Color(hex: "3A6F8F"))
                    .tracking(1.3)
                Text("BESIDE HER THROUGH IT ALL")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "6FA8C4"))
                    .tracking(3.2)
            }
            .padding(.bottom, 24)

            // Subtitle
            Text("Your week-by-week guide to\nsupporting your partner\nthrough pregnancy")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 8)
            
            Spacer()
            
            // Page indicator
            HStack(spacing: 6) {
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
                Text("Get Started")
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

#Preview {
    WelcomeView(onContinue: {})
}
