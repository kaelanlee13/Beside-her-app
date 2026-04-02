//
//  Tip.swift
//  BesideHer
//
//  Models for categorized pregnancy tips
//

import Foundation

// MARK: - Tip Model
struct Tip: Codable, Identifiable {
    let id: String
    let category: String
    let title: String
    let content: String
    let trimester: [Int]
    let tags: [String]
    
    /// Returns a user-friendly category name for display
    var categoryDisplayName: String {
        switch category {
        case "emotional-support": return "Emotional Support"
        case "financial-prep": return "Financial Prep"
        case "home-gear": return "Home & Gear"
        case "labor-prep": return "Labor Prep"
        case "postpartum-prep": return "Postpartum Prep"
        default: return category.capitalized
        }
    }
    
    /// Returns an SF Symbol icon name for the category
    var categoryIcon: String {
        switch category {
        case "emotional-support": return "heart.fill"
        case "financial-prep": return "dollarsign.circle.fill"
        case "home-gear": return "house.fill"
        case "labor-prep": return "cross.case.fill"
        case "postpartum-prep": return "figure.and.child.holdinghands"
        default: return "lightbulb.fill"
        }
    }
}

// MARK: - Tips Response (top-level JSON wrapper)
struct TipsResponse: Codable {
    let tips: [Tip]
}
