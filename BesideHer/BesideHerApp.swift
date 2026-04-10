//
//  BesideHerApp.swift
//  BesideHer
//
//  Created by Kaelan Lee on 4/2/26.
//

import SwiftUI
import SwiftData

@main
struct BesideHerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Migration failed (e.g. schema changed). Delete the old store and start fresh.
            // Safe pre-App Store: no real user data to preserve yet.
            try? FileManager.default.removeItem(at: modelConfiguration.url)
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
