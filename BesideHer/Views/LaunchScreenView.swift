//
//  LaunchScreenView.swift
//  BesideHer
//
//  Animated launch screen shown briefly when the app opens
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var logoScale: CGFloat = 0.85
    @State private var logoOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(hex: "F7F9FC")
                .ignoresSafeArea()

            VStack(spacing: 10) {
                // Wordmark
                Text("besideher")
                    .font(Font.custom("Georgia", size: 46))
                    .foregroundColor(Color(hex: "3A6F8F"))
                    .tracking(1.3)

                // Tagline
                Text("BESIDE HER THROUGH IT ALL")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "6FA8C4"))
                    .tracking(3.2)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.1)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
