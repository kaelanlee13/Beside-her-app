//
//  NotificationService.swift
//  BesideHer
//
//  Handles scheduling and managing weekly push notifications
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    let content = ContentService.shared
    
    private init() {}
    
    // MARK: - Permission
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    // MARK: - Schedule Weekly Notifications
    
    /// Schedules notifications for upcoming weeks based on the due date
    func scheduleWeeklyNotifications(dueDate: Date) {
        // Cancel any existing notifications first
        cancelAllNotifications()
        
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate how many weeks until due date
        let weeksUntilDue = calendar.dateComponents([.weekOfYear], from: now, to: dueDate).weekOfYear ?? 0
        let currentWeek = max(min(40 - weeksUntilDue, 40), 1)
        
        // Schedule notifications for the next 10 weeks (iOS limits pending notifications)
        for weekOffset in 0..<10 {
            let targetWeek = currentWeek + weekOffset
            guard targetWeek <= 40 else { break }
            
            // Get content for this week
            guard let week = content.week(for: targetWeek) else { continue }
            
            // Create notification content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Week \(targetWeek) — BesideHer"
            notificationContent.body = weekNotificationBody(for: week)
            notificationContent.sound = .default
            
            // Schedule for Monday at 9:00 AM
            let triggerDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: now)!
            var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: triggerDate)
            components.weekday = 2  // Monday
            components.hour = 9
            components.minute = 0
            
            // Make sure the trigger date is in the future
            if let scheduledDate = calendar.date(from: components), scheduledDate > now {
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "week-\(targetWeek)",
                    content: notificationContent,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification for week \(targetWeek): \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Cancel
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Notification Content
    
    private func weekNotificationBody(for week: Week) -> String {
        let messages = [
            "Baby is the size of \(week.sizeComparison.lowercased()). Tap to see what's new this week.",
            "New week, new milestones. \(week.commonDadQuestion ?? "Tap to find out what's happening.") Find out inside.",
            "Week \(week.weekNumber) is here. Your partner needs you — here's how to show up.",
            "Your baby is growing! Tap to see this week's action items.",
        ]
        return messages.randomElement() ?? messages[0]
    }
}
