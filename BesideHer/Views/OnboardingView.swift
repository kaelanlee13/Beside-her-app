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
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "F7F9FC")
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
                NotificationView(
                    onEnable: {
                        requestNotifications()
                        completeOnboarding()
                    },
                    onSkip: {
                        completeOnboarding()
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
                
            default:
                EmptyView()
            }
        }
    }
    
    private func completeOnboarding() {
        // Create the user profile with the selected due date
        let profile = UserProfile(
            dueDate: dueDate,
            onboardingCompleted: true,
            notificationsEnabled: currentStep == 2
        )
        modelContext.insert(profile)
        
        // Notify parent view that onboarding is done
        onComplete()
    }
    
    private func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .modelContainer(for: UserProfile.self, inMemory: true)
}
