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
    var completedActionItems: [String]    // stores action item IDs
    var completedChecklistItems: [String] // stores checklist item IDs
    var bookmarkedTips: [String]          // stores tip IDs
    var createdAt: Date
    
    init(
        dueDate: Date,
        onboardingCompleted: Bool = false,
        notificationsEnabled: Bool = false,
        completedActionItems: [String] = [],
        completedChecklistItems: [String] = [],
        bookmarkedTips: [String] = [],
        createdAt: Date = Date()
    ) {
        self.dueDate = dueDate
        self.onboardingCompleted = onboardingCompleted
        self.notificationsEnabled = notificationsEnabled
        self.completedActionItems = completedActionItems
        self.completedChecklistItems = completedChecklistItems
        self.bookmarkedTips = bookmarkedTips
        self.createdAt = createdAt
    }
    
    /// Calculates the current pregnancy week based on the due date
    /// Pregnancy is 40 weeks, so current week = 40 - (weeks until due date)
    var currentWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weeksUntilDue = calendar.dateComponents([.weekOfYear], from: now, to: dueDate).weekOfYear ?? 0
        let week = 40 - weeksUntilDue
        return min(max(week, 1), 40) // clamp between 1 and 40
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
