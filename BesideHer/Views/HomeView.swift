//
//  HomeView.swift
//  BesideHer
//
//  Main home screen showing current week and pregnancy progress
//

import SwiftUI

struct HomeView: View {
    let profile: UserProfile
    let content = ContentService.shared
    
    var currentWeekContent: Week? {
        content.week(for: profile.currentWeek)
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Good \(greeting)")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "5A6B80"))
                            Text("Week \(profile.currentWeek)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "1A2B42"))
                            Text(countdownText)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "3B7DD8"))
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView(profile: profile)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .frame(width: 38, height: 38)
                                    .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                                    )
                                Image(systemName: "gearshape")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "5A6B80"))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Progress card
                    VStack(spacing: 8) {
                        HStack {
                            Text("Pregnancy Progress")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "5A6B80"))
                            Spacer()
                            Text("\(Int(profile.progressPercentage * 100))%")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "3B7DD8"))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: "E8F0FE"))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "3B7DD8"), Color(hex: "2B5EA7")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * profile.progressPercentage, height: 8)
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text("Week 1")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "8E9BAD"))
                            Spacer()
                            Text("Week 40")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "8E9BAD"))
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // This week card — tappable
                    if let week = currentWeekContent {
                        NavigationLink(destination: WeekDetailView(week: week, profile: profile)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("THIS WEEK")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.7))
                                            .tracking(1)
                                        
                                        Text("Baby is the size of \(articleFor(week.babySize)) \(week.babySize.lowercased())")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                        
                                    }
                                    Spacer()
                                }
                                
                                Divider()
                                    .background(.white.opacity(0.2))
                                
                                Text("Read full week guide →")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "3B7DD8"), Color(hex: "2B5EA7")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(hex: "3B7DD8").opacity(0.25), radius: 8, y: 4)
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Quick action buttons
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        NavigationLink(destination: ChecklistsView(profile: profile)) {
                            quickActionButton(icon: "checklist", label: "Checklists")
                        }
                        NavigationLink(destination: AllWeeksView(profile: profile)) {
                            quickActionButton(icon: "calendar", label: "All Weeks")
                        }
                        NavigationLink(destination: TipsCategoryView(profile: profile)) {
                            quickActionButton(icon: "heart.fill", label: "Tips")
                        }
                        NavigationLink(destination: ContractionTimerView()) {
                            quickActionButton(icon: "waveform.path.ecg", label: "Contractions")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // This week's tasks
                    if let week = currentWeekContent {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("This Week's Tasks")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "1A2B42"))
                                Spacer()
                                let completed = week.actionItems.filter { profile.isActionItemCompleted($0.id) }.count
                                Text("\(completed) of \(week.actionItems.count)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                            }
                            
                            ForEach(week.actionItems) { item in
                                HStack(spacing: 12) {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            profile.toggleActionItem(item.id)
                                        }
                                    }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(profile.isActionItemCompleted(item.id) ? Color(hex: "3B7DD8") : .clear)
                                                .frame(width: 22, height: 22)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(profile.isActionItemCompleted(item.id) ? Color.clear : Color(hex: "E4EAF1"), lineWidth: 1.5)
                                                )
                                            
                                            if profile.isActionItemCompleted(item.id) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    
                                    Text(item.text)
                                        .font(.system(size: 14))
                                        .foregroundColor(profile.isActionItemCompleted(item.id) ? Color(hex: "8E9BAD") : Color(hex: "1A2B42"))
                                        .strikethrough(profile.isActionItemCompleted(item.id))
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }

                    // Common Dad Question card
                    if let week = currentWeekContent {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                                Text("Common Dad Question")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "3B7DD8"))
                            }

                            Text(week.commonDadQuestion)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "1A2B42"))

                            Text(week.commonDadAnswer)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "5A6B80"))
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(hex: "F7F9FC"))
        }
    }
    
    private func quickActionButton(icon: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "3B7DD8"))
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "5A6B80"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
        )
    }
    
    private var countdownText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: profile.dueDate)
        let days = calendar.dateComponents([.day], from: today, to: due).day ?? 0

        switch days {
        case ..<0: return "Overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")"
        case 0:    return "Today is your due date!"
        case 1:    return "1 day to go"
        default:   return "\(days) days to go"
        }
    }

    private func articleFor(_ word: String) -> String {
        let lower = word.lowercased()
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        if let first = lower.first, vowels.contains(first) {
            return "an"
        }
        return "a"
    }
}

#Preview {
    HomeView(profile: UserProfile(
        dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
        onboardingCompleted: true
    ))
}
