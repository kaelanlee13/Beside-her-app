//
//  PregnancyFact.swift
//  BesideHer
//
//  Model for week-by-week pregnancy facts
//

import Foundation

struct PregnancyFact: Codable, Identifiable {
    let week: String
    let fact: String

    var id: String { week }
}

struct PregnancyFactsResponse: Codable {
    let title: String
    let data: [PregnancyFact]
}
