//
//  ChecklistsView.swift
//  BesideHer
//
//  Trimester-based checklists with tabs, progress, and completion tracking
//

import SwiftUI

struct ChecklistsView: View {
    let profile: UserProfile
    let content = ContentService.shared
    
    @State private var selectedTrimester = 1
    
    var currentChecklist: Checklist? {
        content.checklist(forTrimester: selectedTrimester)
    }
    
    var completedCount: Int {
        guard let checklist = currentChecklist else { return 0 }
        return checklist.items.filter { profile.isChecklistItemCompleted($0.id) }.count
    }
    
    var totalCount: Int {
        currentChecklist?.items.count ?? 0
    }
    
    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Hospital Bag shortcut
                NavigationLink(destination: LaborBagView(profile: profile)) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "E8F0FE"))
                                .frame(width: 44, height: 44)
                            Text("🏥")
                                .font(.system(size: 22))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hospital Bag")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "1A2B42"))
                            Text("Pack before week 36")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "5A6B80"))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "8E9BAD"))
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)

                // Trimester tabs
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { trimester in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTrimester = trimester
                            }
                        }) {
                            Text(trimesterLabel(trimester))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(selectedTrimester == trimester ? .white : Color(hex: "5A6B80"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedTrimester == trimester ? Color(hex: "3B7DD8") : .white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTrimester == trimester ? Color.clear : Color(hex: "E4EAF1"), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Progress card
                VStack(spacing: 8) {
                    HStack {
                        Text("\(trimesterLabel(selectedTrimester)) Progress")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "1A2B42"))
                        Spacer()
                        Text("\(completedCount) of \(totalCount)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "3B7DD8"))
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: "E8F0FE"))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: "3B7DD8"))
                                .frame(width: geo.size.width * progressPercentage, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                // Checklist items
                if let checklist = currentChecklist {
                    VStack(spacing: 0) {
                        ForEach(Array(checklist.items.enumerated()), id: \.element.id) { index, item in
                            VStack(spacing: 0) {
                                if index > 0 {
                                    Divider()
                                        .padding(.leading, 44)
                                }
                                
                                HStack(spacing: 12) {
                                    // Checkbox
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            profile.toggleChecklistItem(item.id)
                                        }
                                    }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(profile.isChecklistItemCompleted(item.id) ? Color(hex: "3B7DD8") : .clear)
                                                .frame(width: 22, height: 22)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(profile.isChecklistItemCompleted(item.id) ? Color.clear : Color(hex: "E4EAF1"), lineWidth: 1.5)
                                                )
                                            
                                            if profile.isChecklistItemCompleted(item.id) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    
                                    // Item text and category
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(item.text)
                                            .font(.system(size: 14))
                                            .foregroundColor(profile.isChecklistItemCompleted(item.id) ? Color(hex: "8E9BAD") : Color(hex: "1A2B42"))
                                            .strikethrough(profile.isChecklistItemCompleted(item.id))
                                            .multilineTextAlignment(.leading)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: item.categoryIcon)
                                                .font(.system(size: 9))
                                            Text(item.categoryDisplayName)
                                                .font(.system(size: 11))
                                        }
                                        .foregroundColor(Color(hex: "8E9BAD"))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
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
        .navigationTitle("Checklists")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Default to the user's current trimester
            selectedTrimester = profile.currentTrimester
        }
    }
    
    private func trimesterLabel(_ trimester: Int) -> String {
        switch trimester {
        case 1: return "1st Tri"
        case 2: return "2nd Tri"
        case 3: return "3rd Tri"
        default: return "Tri \(trimester)"
        }
    }
}

#Preview {
    NavigationStack {
        ChecklistsView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
            onboardingCompleted: true
        ))
    }
}
