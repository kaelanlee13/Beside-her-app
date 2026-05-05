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
    @State private var selectedTab: Int = 0

    init(profile: UserProfile) {
        self.profile = profile
        Self.configureTabBarAppearance()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(profile: profile)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            AllWeeksView(profile: profile)
                .tabItem {
                    Label("Weeks", systemImage: "calendar")
                }
                .tag(1)

            ChecklistsView(profile: profile)
                .tabItem {
                    Label("Checklist", systemImage: selectedTab == 2 ? "checkmark.circle.fill" : "checkmark.circle")
                }
                .tag(2)

            TipsCategoryView(profile: profile)
                .tabItem {
                    Label("Tips", systemImage: selectedTab == 3 ? "lightbulb.fill" : "lightbulb")
                }
                .tag(3)
        }
        .tint(Color.accent)
        .toolbarBackground(Color.surface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
        .tabBarMinimizeOnScrollDownIfAvailable()
    }

    private static func configureTabBarAppearance() {
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

        // SF Pro Rounded 10pt Semibold for tab labels
        let labelFont: UIFont = {
            let base = UIFont.systemFont(ofSize: 10, weight: .semibold)
            if let rounded = base.fontDescriptor.withDesign(.rounded) {
                return UIFont(descriptor: rounded, size: 10)
            }
            return base
        }()
        let item = UITabBarItemAppearance()
        item.normal.titleTextAttributes = [.font: labelFont]
        item.selected.titleTextAttributes = [.font: labelFont]
        appearance.stackedLayoutAppearance = item
        appearance.inlineLayoutAppearance = item
        appearance.compactInlineLayoutAppearance = item

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - iOS 26 conditional modifiers

extension View {
    /// Applies `tabBarMinimizeBehavior(.onScrollDown)` on iOS 26+; no-op otherwise.
    @ViewBuilder
    func tabBarMinimizeOnScrollDownIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }

    /// Applies `scrollEdgeEffectStyle(.soft, for: .all)` on iOS 26+; no-op otherwise.
    @ViewBuilder
    func softScrollEdgeEffect() -> some View {
        if #available(iOS 26.0, *) {
            self.scrollEdgeEffectStyle(.soft, for: .all)
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
