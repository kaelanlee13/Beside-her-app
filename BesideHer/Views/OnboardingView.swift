//
//  OnboardingView.swift
//  BesideHer
//
//  Container view that manages the 3-step onboarding flow
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentStep = 0
    @State private var dueDate = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
    @State private var babyGender = "unknown"
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color.paper
                .ignoresSafeArea()
            
            switch currentStep {
            case 0:
                WelcomeView(onContinue: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = 1
                    }
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case 1:
                DueDateView(
                    dueDate: $dueDate,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 2
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 0
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))

            case 2:
                GenderView(
                    babyGender: $babyGender,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 3
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 1
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))

            case 3:
                NotificationView(
                    onEnable: {
                        completeOnboarding(notificationsEnabled: true)
                        NotificationService.shared.requestPermission { granted in
                            if granted {
                                NotificationService.shared.scheduleWeeklyNotifications(dueDate: dueDate)
                            }
                        }
                    },
                    onSkip: {
                        completeOnboarding(notificationsEnabled: false)
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 2
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            default:
                EmptyView()
            }
        }
    }
    
    private func completeOnboarding(notificationsEnabled: Bool) {
        let profile = UserProfile(
            dueDate: dueDate,
            onboardingCompleted: true,
            notificationsEnabled: notificationsEnabled,
            babyGender: babyGender
        )
        modelContext.insert(profile)
        onComplete()
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .modelContainer(for: UserProfile.self, inMemory: true)
}
