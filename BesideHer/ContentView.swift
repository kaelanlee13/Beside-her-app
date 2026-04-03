//
//  ContentView.swift
//  BesideHer
//
//  Root view that manages launch screen, onboarding, and main app routing
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @State private var showOnboarding = false
    @State private var showLaunchScreen = true
    
    var userProfile: UserProfile? {
        profiles.first { $0.onboardingCompleted }
    }
    
    var body: some View {
        ZStack {
            Group {
                if let profile = userProfile, !showOnboarding {
                    HomeView(profile: profile)
                        .onAppear {
                            // Schedule notifications if enabled
                            if profile.notificationsEnabled {
                                NotificationService.shared.scheduleWeeklyNotifications(dueDate: profile.dueDate)
                            }
                        }
                } else {
                    OnboardingView(onComplete: {
                        withAnimation {
                            showOnboarding = false
                        }
                    })
                }
            }
            .opacity(showLaunchScreen ? 0 : 1)
            
            // Launch screen overlay
            if showLaunchScreen {
                LaunchScreenView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show launch screen for 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
