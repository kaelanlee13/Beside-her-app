//
//  UserProfile.swift
//  BesideHer
//
//  SwiftData model for storing user preferences and progress locally
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var dueDate: Date
    var onboardingCompleted: Bool
    var notificationsEnabled: Bool
    var babyGender: String                 // "boy", "girl", or "unknown"
    var completedActionItems: [String]    // stores action item IDs
    var completedChecklistItems: [String] // stores checklist item IDs
    var bookmarkedTips: [String]          // stores tip IDs
    var createdAt: Date

    init(
        dueDate: Date,
        onboardingCompleted: Bool = false,
        notificationsEnabled: Bool = false,
        babyGender: String = "unknown",
        completedActionItems: [String] = [],
        completedChecklistItems: [String] = [],
        bookmarkedTips: [String] = [],
        createdAt: Date = Date()
    ) {
        self.dueDate = dueDate
        self.onboardingCompleted = onboardingCompleted
        self.notificationsEnabled = notificationsEnabled
        self.babyGender = babyGender
        self.completedActionItems = completedActionItems
        self.completedChecklistItems = completedChecklistItems
        self.bookmarkedTips = bookmarkedTips
        self.createdAt = createdAt
    }
    
    /// Current pregnancy week (1–40), measured as completed weeks since LMP.
    /// Pregnancy is 280 days; due date is day 280. Day-precision avoids the
    /// off-by-one that .weekOfYear introduces when there's a partial week.
    var currentWeek: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)
        let daysUntilDue = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        let daysIntoPregnancy = 280 - daysUntilDue
        let week = daysIntoPregnancy / 7
        return min(max(week, 1), 40)
    }
    
    /// Returns the current trimester (1, 2, or 3)
    var currentTrimester: Int {
        switch currentWeek {
        case 1...13: return 1
        case 14...27: return 2
        default: return 3
        }
    }
    
    /// Returns pregnancy progress as a percentage (0.0 to 1.0)
    var progressPercentage: Double {
        return Double(currentWeek) / 40.0
    }
    
    /// Checks if a specific action item is completed
    func isActionItemCompleted(_ id: String) -> Bool {
        completedActionItems.contains(id)
    }
    
    /// Toggles an action item's completion status
    func toggleActionItem(_ id: String) {
        if completedActionItems.contains(id) {
            completedActionItems.removeAll { $0 == id }
        } else {
            completedActionItems.append(id)
        }
    }
    
    /// Checks if a specific checklist item is completed
    func isChecklistItemCompleted(_ id: String) -> Bool {
        completedChecklistItems.contains(id)
    }
    
    /// Toggles a checklist item's completion status
    func toggleChecklistItem(_ id: String) {
        if completedChecklistItems.contains(id) {
            completedChecklistItems.removeAll { $0 == id }
        } else {
            completedChecklistItems.append(id)
        }
    }
    
    /// Checks if a tip is bookmarked
    func isTipBookmarked(_ id: String) -> Bool {
        bookmarkedTips.contains(id)
    }
    
    /// Toggles a tip's bookmark status
    func toggleBookmark(_ id: String) {
        if bookmarkedTips.contains(id) {
            bookmarkedTips.removeAll { $0 == id }
        } else {
            bookmarkedTips.append(id)
        }
    }
}
