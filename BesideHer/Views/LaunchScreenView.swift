//
//  LaunchScreenView.swift
//  BesideHer
//
//  Animated launch screen shown briefly when the app opens
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var iconScale: CGFloat = 0.6
    @State private var iconOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color(hex: "F7F9FC")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
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
                        .shadow(color: Color(hex: "3B7DD8").opacity(0.3), radius: 16, y: 6)
                    
                    Text("👶")
                        .font(.system(size: 36))
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)
                
                // App name
                VStack(spacing: 4) {
                    Text("BesideHer")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "1A2B42"))
                    
                    Text("Be the partner she needs")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "5A6B80"))
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
