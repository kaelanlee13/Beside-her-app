//
//  Week.swift
//  BesideHer
//
//  Models for week-by-week pregnancy content
//

import Foundation

// MARK: - Week Model
struct Week: Codable, Identifiable {
    let weekNumber: Int
    let trimester: Int
    let title: String
    let sizeComparison: String
    let sizeEmoji: String
    let babyDevelopment: String
    let partnerExperience: String
    let howToHelp: String
    let actionItems: [ActionItem]
    let commonDadQuestion: String?
    let commonDadAnswer: String?
    
    var id: Int { weekNumber }
}

// MARK: - Action Item
struct ActionItem: Codable, Identifiable {
    let id: String
    let text: String
    let category: String
}

// MARK: - Weeks Response (top-level JSON wrapper)
struct WeeksResponse: Codable {
    let weeks: [Week]
}
