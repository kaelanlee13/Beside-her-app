# BesideHer – iOS App

## App Overview
Pregnancy tracker app for first-time dads. Helps dads stay engaged, prepared,
and informed throughout pregnancy and labor. Originally called "Dad Prep App",
renamed to BesideHer.

**Target audience:** First-time fathers  
**Platform:** iOS (iPhone only for v1, iPad later)  
**Minimum iOS version:** iOS 17+  
**App Store status:** Pre-submission (MVP complete, in App Store prep phase)

---

## Tech Stack
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Data persistence:** SwiftData
- **Content delivery:** Bundled JSON files (no backend)
- **Notifications:** UserNotifications framework (local only)
- **Architecture:** MVVM
- **Version control:** Git + GitHub (github.com/kaelanlee13/beside-her-app)
- **Local project path:** ~/Desktop/BesideHer

---

## Project Structure
```
BesideHer/
├── Models/
│   ├── Week.swift
│   ├── Tip.swift
│   ├── Checklist.swift
│   └── UserProfile.swift        # SwiftData model
├── Views/
│   ├── LaunchScreenView.swift   # Splash screen with spring animation
│   ├── Onboarding/              # 3-screen onboarding flow
│   ├── HomeView.swift
│   ├── WeekDetailView.swift
│   ├── AllWeeksView.swift
│   ├── ChecklistsView.swift
│   ├── TipsCategoryView.swift
│   └── SettingsView.swift
├── Services/
│   ├── ContentService.swift     # Singleton, loads JSON content
│   └── NotificationService.swift
├── Resources/
│   ├── weeks.json               # 38 entries
│   ├── tips.json                # 72 tips across 5 categories
│   └── checklists.json          # 45 items across 3 trimesters
└── Utilities/
    ├── AppTheme.swift           # Color/font constants, primary blue #3B7DD8
    └── Color+Hex.swift          # Hex color utility extension
```

---

## What's Been Built (MVP Complete)

### Content
- `weeks.json` — 38 weeks of pregnancy content
- `tips.json` — 72 tips across 5 categories: Emotional Support, Financial Prep, Home & Gear, Labor Prep, Postpartum Prep
- `checklists.json` — 45 checklist items across 3 trimesters

### Data Models
- `Week.swift` — week number, baby development, partner experience, how-to-help, actionable items
- `Tip.swift` — tip content with category
- `Checklist.swift` — checklist items with trimester grouping
- `UserProfile.swift` — SwiftData model storing due date and notification preferences

### Screens
- **Onboarding flow** (3 screens): Welcome → Due date picker → Notification permission
- **HomeView** — Current week display, progress bar, "What's Happening This Week" card, quick action buttons
- **WeekDetailView** — Baby development, partner experience, how-to-help, actionable checkboxes
- **AllWeeksView** — Browse all 40 weeks
- **ChecklistsView** — Trimester-based checklists with completion tracking
- **TipsCategoryView** — Browse tips filtered by category
- **SettingsView** — Edit due date, notification preferences, about

### Infrastructure
- `ContentService.swift` — Singleton that loads all JSON bundles
- `NotificationService.swift` — Schedules weekly push notifications based on due date
- `LaunchScreenView.swift` — Splash screen with spring animation
- `AppTheme.swift` — Centralized design constants
- `Color+Hex.swift` — Hex color utility

---

## What's In Progress / Next
- App Store submission preparation
- Pre-submission testing and polish
- Screenshots, App Store description, privacy policy

---

## Design & UI Conventions
- **Primary color:** `#3B7DD8` (blue)
- **Aesthetic:** Clean, minimal, calming
- Use SwiftUI for all views
- No backend — all content is local/bundled
- Use `AppTheme` constants for colors and fonts, never hardcode

---

## Key Architecture Decisions
- **No backend for v1** — all content bundled with app, updates via App Store releases
- **SwiftData** for local persistence only (checklist completion, due date, bookmarks)
- **ContentService** is a singleton — always use it to access JSON content, never load JSON directly in views
- **MVVM pattern** — keep business logic out of views

---

## Development Workflow
- Developer is a first-time iOS developer learning through building
- "Vibe coding" approach: Claude generates complete Swift files, developer drags into Xcode
- Build in Xcode to verify — running simulator after every change is not required
- One file at a time is preferred for clarity
- Git recovery pattern: if project gets corrupted, clone from GitHub and force-push

---

## Known Issues / Watch Out For
- Git/file management has caused issues before (corrupted folders, merge conflicts, accidentally deleted files)
- Reliable recovery: clone from GitHub, make changes, force-push
- Keep MVP scope tight — no backend, no dynamic content, three content categories only

---

## Coding Conventions
- Use SwiftUI for all new views
- Use `@StateObject` / `@ObservedObject` appropriately for ViewModels
- Use `@Environment(\.modelContext)` for SwiftData operations
- Always use `AppTheme` for colors and typography
- Keep views focused — extract subviews when a view gets complex
- Prefer named constants over magic numbers/strings
