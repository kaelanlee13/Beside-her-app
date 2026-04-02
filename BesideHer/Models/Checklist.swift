//
//  Checklist.swift
//  BesideHer
//
//  Models for trimester-based checklists
//

import Foundation

// MARK: - Checklist Model
struct Checklist: Codable, Identifiable {
    let id: String
    let title: String
    let trimester: Int
    let items: [ChecklistItem]
}

// MARK: - Checklist Item
struct ChecklistItem: Codable, Identifiable {
    let id: String
    let text: String
    let category: String
    let weekRecommended: Int
    
    /// Returns a user-friendly category name for display
    var categoryDisplayName: String {
        switch category {
        case "medical": return "Medical"
        case "financial": return "Financial"
        case "health": return "Health"
        case "gear": return "Gear"
        case "emotional": return "Emotional"
        case "planning": return "Planning"
        case "postpartum": return "Postpartum"
        default: return category.capitalized
        }
    }
    
    /// Returns an SF Symbol icon name for the category
    var categoryIcon: String {
        switch category {
        case "medical": return "stethoscope"
        case "financial": return "dollarsign.circle"
        case "health": return "heart"
        case "gear": return "cart"
        case "emotional": return "face.smiling"
        case "planning": return "calendar"
        case "postpartum": return "figure.and.child.holdinghands"
        default: return "checklist"
        }
    }
}

// MARK: - Checklists Response (top-level JSON wrapper)
struct ChecklistsResponse: Codable {
    let checklists: [Checklist]
}
