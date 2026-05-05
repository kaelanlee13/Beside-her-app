//
//  ContractionRecord.swift
//  BesideHer
//
//  SwiftData model for a single contraction. Persists across app launches so
//  history and an in-progress timer survive backgrounding or termination.
//
//  An active contraction has endTime == nil. On relaunch, elapsed time is
//  recomputed from startTime, so the timer resumes seamlessly.
//

import Foundation
import SwiftData

@Model
final class ContractionRecord {
    var startTime: Date
    var endTime: Date?

    init(startTime: Date, endTime: Date? = nil) {
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension ContractionRecord {
    var isActive: Bool { endTime == nil }

    /// Final duration in seconds, or nil while the contraction is still in progress.
    var duration: TimeInterval? {
        guard let endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
}
