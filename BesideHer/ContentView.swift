//
//  ContentView.swift
//  BesideHer
//
//  Root view that checks onboarding status and routes accordingly
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @State private var showOnboarding = false
    
    /// The user's profile, if onboarding is complete
    var userProfile: UserProfile? {
        profiles.first { $0.onboardingCompleted }
    }
    
    var body: some View {
        Group {
            if let profile = userProfile, !showOnboarding {
                // User has completed onboarding — show the main app
                HomeView(profile: profile)
            } else {
                // First time user — show onboarding
                OnboardingView(onComplete: {
                    withAnimation {
                        showOnboarding = false
                    }
                })
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
