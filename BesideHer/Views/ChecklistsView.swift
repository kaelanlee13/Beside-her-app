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
    @State private var selectedCategory: String? = nil

    var currentChecklist: Checklist? {
        content.checklist(forTrimester: selectedTrimester)
    }

    var availableCategories: [String] {
        guard let checklist = currentChecklist else { return [] }
        var seen = Set<String>()
        return checklist.items.compactMap { item in
            seen.insert(item.category).inserted ? item.category : nil
        }
    }

    var filteredItems: [ChecklistItem] {
        guard let checklist = currentChecklist else { return [] }
        guard let category = selectedCategory else { return checklist.items }
        return checklist.items.filter { $0.category == category }
    }

    var completedCount: Int {
        filteredItems.filter { profile.isChecklistItemCompleted($0.id) }.count
    }

    var totalCount: Int { filteredItems.count }

    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    // Groups items by category; single group when a filter is active.
    var groupedItems: [(category: String, items: [ChecklistItem])] {
        if let cat = selectedCategory {
            return [(category: cat, items: filteredItems)]
        }
        return availableCategories.compactMap { cat in
            let items = filteredItems.filter { $0.category == cat }
            return items.isEmpty ? nil : (category: cat, items: items)
        }
    }

    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(spacing: 16) {

                // Hospital Bag shortcut
                NavigationLink(destination: LaborBagView(profile: profile)) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accent.opacity(0.1))
                                .frame(width: 44, height: 44)
                            Image(systemName: "bag.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.accent)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hospital Bag")
                                .font(.h2)
                                .foregroundStyle(Color.ink)
                            Text("Pack before week 36")
                                .font(.captionText)
                                .foregroundStyle(Color.inkSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.inkSecondary)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.surface)
                            .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.divider, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)

                // Trimester selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach([1, 2, 3, 0], id: \.self) { trimester in
                            FilterChip(
                                title: trimesterLabel(trimester),
                                isSelected: selectedTrimester == trimester,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedTrimester = trimester
                                    }
                                },
                                horizontalPadding: 18,
                                verticalPadding: 10
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 2)
                }
                .scrollIndicators(.hidden)
                .padding(.top, 8)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedCategory = nil
                                }
                            }
                        )
                        ForEach(availableCategories, id: \.self) { category in
                            FilterChip(
                                title: ChecklistItem.categoryDisplayName(for: category),
                                isSelected: selectedCategory == category,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 2)
                }
                .scrollIndicators(.hidden)

                // Quiet progress header — no card, sits on Color.paper
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("PROGRESS")
                        .eyebrowStyle()

                    Text("\(completedCount) of \(totalCount) complete")
                        .font(.h1)
                        .foregroundStyle(Color.ink)

                    HairlineProgressRuler(progress: progressPercentage)
                        .padding(.top, Spacing.xs)
                }
                .padding(.horizontal, 20)
                .padding(.top, Spacing.sm)

                // Checklist items — editorial flat rows, grouped by category
                if filteredItems.isEmpty {
                    Text("No items for this selection.")
                        .font(.captionText)
                        .foregroundStyle(Color.inkSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                } else {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(groupedItems, id: \.category) { group in
                            Section {
                                ForEach(Array(group.items.enumerated()), id: \.element.id) { index, item in
                                    ChecklistRow(
                                        title: item.text,
                                        description: item.description,
                                        category: nil,
                                        isComplete: profile.isChecklistItemCompleted(item.id),
                                        onToggle: { profile.toggleChecklistItem(item.id) },
                                        showDivider: index < group.items.count - 1
                                    )
                                }
                                .padding(.horizontal, 20)
                            } header: {
                                if selectedCategory == nil {
                                    Text(ChecklistItem.categoryDisplayName(for: group.category))
                                        .eyebrowStyle()
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        .padding(.bottom, 2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.paper)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 32)
        }
        .softScrollEdgeEffect()
        .background(Color.paper)
        .navigationTitle("Checklists")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedTrimester = profile.currentTrimester
        }
        .onChange(of: selectedTrimester) { _, _ in
            selectedCategory = nil
        }
        } // NavigationStack
    }

    private func trimesterLabel(_ trimester: Int) -> String {
        switch trimester {
        case 0: return "Ongoing"
        case 1: return "1st Tri"
        case 2: return "2nd Tri"
        case 3: return "3rd Tri"
        default: return "Tri \(trimester)"
        }
    }
}

