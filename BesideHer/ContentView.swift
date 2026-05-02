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
        appearance.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x1E/255, green: 0x1A/255, blue: 0x16/255, alpha: 1) // surface dark
                : UIColor(red: 0xFB/255, green: 0xF8/255, blue: 0xF2/255, alpha: 1) // surface light
        }
        appearance.shadowColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x2E/255, green: 0x29/255, blue: 0x25/255, alpha: 1) // divider dark
                : UIColor(red: 0xE7/255, green: 0xDF/255, blue: 0xD2/255, alpha: 1) // divider light
        }
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
