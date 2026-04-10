//
//  ContentView.swift
//  BesideHer
//
//  Root view — manages launch screen, onboarding, and main tab navigation
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
                    MainTabView(profile: profile)
                        .onAppear {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    let profile: UserProfile

    /// Keeps tab bar background opaque white with no blur artifact
    init(profile: UserProfile) {
        self.profile = profile
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        // Hairline separator
        appearance.shadowColor = UIColor(AppTheme.border)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView(profile: profile)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            AllWeeksView(profile: profile)
                .tabItem {
                    Label("Weeks", systemImage: "calendar")
                }

            ChecklistsView(profile: profile)
                .tabItem {
                    Label("Checklist", systemImage: "checkmark.circle.fill")
                }

            TipsCategoryView(profile: profile)
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.fill")
                }
        }
        .tint(AppTheme.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
