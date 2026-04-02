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
            
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "3B7DD8"), Color(hex: "2B5EA7")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color(hex: "3B7DD8").opacity(0.3), radius: 12, y: 4)
                
                Text("👶")
                    .font(.system(size: 36))
            }
            .padding(.bottom, 24)
            
            // Title
            Text("BesideHer")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
            
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
