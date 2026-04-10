//
//  ContentService.swift
//  BesideHer
//
//  Loads and provides access to bundled JSON content (weeks, tips, checklists)
//

import Foundation

class ContentService {
    
    // Singleton so the content is loaded once and shared across the app
    static let shared = ContentService()
    
    // Loaded content
    let weeks: [Week]
    let tips: [Tip]
    let checklists: [Checklist]
    
    private init() {
        self.weeks = ContentService.loadWeeks()
        self.tips = ContentService.loadTips()
        self.checklists = ContentService.loadChecklists()
    }
    
    // MARK: - Loading Functions
    
    private static func loadWeeks() -> [Week] {
        guard let data = loadJSON(filename: "weeks") else { return [] }
        do {
            let response = try JSONDecoder().decode(WeeksResponse.self, from: data)
            return response.weeks.sorted { $0.weekNumber < $1.weekNumber }
        } catch {
            print("Error decoding weeks.json: \(error)")
            return []
        }
    }
    
    private static func loadTips() -> [Tip] {
        guard let data = loadJSON(filename: "tips") else { return [] }
        do {
            let response = try JSONDecoder().decode(TipsResponse.self, from: data)
            return response.tips
        } catch {
            print("Error decoding tips.json: \(error)")
            return []
        }
    }
    
    private static func loadChecklists() -> [Checklist] {
        guard let data = loadJSON(filename: "checklists") else { return [] }
        do {
            let response = try JSONDecoder().decode(ChecklistsResponse.self, from: data)
            return response.checklists.sorted { $0.trimester < $1.trimester }
        } catch {
            print("Error decoding checklists.json: \(error)")
            return []
        }
    }
    
    private static func loadJSON(filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Could not find \(filename).json in bundle")
            return nil
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Could not load \(filename).json: \(error)")
            return nil
        }
    }
    
    // MARK: - Query Functions
    
    /// Get a specific week by week number
    func week(for weekNumber: Int) -> Week? {
        weeks.first { $0.weekNumber == weekNumber }
    }
    
    /// Get all weeks for a specific trimester
    func weeks(forTrimester trimester: Int) -> [Week] {
        weeks.filter { $0.trimester == trimester }
    }
    
    /// Get tips for a specific category
    func tips(forCategory category: String) -> [Tip] {
        tips.filter { $0.category == category }
    }
    
    /// Get tips relevant to a specific trimester
    func tips(forTrimester trimester: Int) -> [Tip] {
        tips.filter { $0.trimester.contains(trimester) }
    }
    
    /// Get tips by their IDs
    func tips(withIDs ids: [String]) -> [Tip] {
        tips.filter { ids.contains($0.id) }
    }
    
    /// Get the checklist for a specific trimester
    func checklist(forTrimester trimester: Int) -> Checklist? {
        checklists.first { $0.trimester == trimester }
    }
    
    /// Get all unique tip categories
    var tipCategories: [String] {
        Array(Set(tips.map { $0.category })).sorted()
    }
}
