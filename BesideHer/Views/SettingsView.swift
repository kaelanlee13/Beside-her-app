//
//  SettingsView.swift
//  BesideHer
//
//  Settings screen for editing due date, notifications, bookmarks, and app info
//

import SwiftUI

struct SettingsView: View {
    let profile: UserProfile
    let content = ContentService.shared

    @State private var showDatePicker = false
    @State private var editedDueDate: Date = Date()
    @State private var showGenderPicker = false
    @State private var showAbout = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false

    var bookmarkedTips: [Tip] {
        content.tips(withIDs: profile.bookmarkedTips)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // ─── Pregnancy Info ──────────────────────────────────────
                VStack(spacing: 0) {
                    settingsRow(
                        systemImage: "calendar",
                        iconColor: AppTheme.primary,
                        label: "Due Date",
                        value: formattedDueDate,
                        showChevron: true,
                        action: {
                            editedDueDate = profile.dueDate
                            showDatePicker = true
                        }
                    )
                    Divider().padding(.leading, 52)
                    settingsRow(
                        systemImage: "figure.child",
                        iconColor: AppTheme.accent,
                        label: "Baby's Gender",
                        value: genderLabel,
                        showChevron: true,
                        action: { showGenderPicker = true }
                    )
                    Divider().padding(.leading, 52)
                    settingsRow(
                        systemImage: "calendar.badge.clock",
                        iconColor: AppTheme.softBlue,
                        label: "Current Week",
                        value: "Week \(profile.currentWeek)",
                        showChevron: false,
                        action: {}
                    )
                    Divider().padding(.leading, 52)
                    settingsRow(
                        systemImage: "list.bullet.clipboard",
                        iconColor: Color(hex: "8B6CC1"),
                        label: "Trimester",
                        value: trimesterLabel,
                        showChevron: false,
                        action: {}
                    )
                }
                .background(whiteCard)
                .padding(.horizontal, 20)

                // ─── Notifications ───────────────────────────────────────
                sectionHeader("Notifications")

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        iconBadge(systemImage: "bell.fill", color: AppTheme.accent)
                        Text("Weekly Reminders")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { profile.notificationsEnabled },
                            set: { newValue in
                                profile.notificationsEnabled = newValue
                                if newValue {
                                    NotificationService.shared.requestPermission { granted in
                                        if granted {
                                            NotificationService.shared.scheduleWeeklyNotifications(dueDate: profile.dueDate)
                                        }
                                    }
                                } else {
                                    NotificationService.shared.cancelAllNotifications()
                                }
                            }
                        ))
                        .tint(AppTheme.primary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .background(whiteCard)
                .padding(.horizontal, 20)

                // ─── Saved ───────────────────────────────────────────────
                sectionHeader("Saved")

                VStack(spacing: 0) {
                    if bookmarkedTips.isEmpty {
                        HStack(spacing: 12) {
                            iconBadge(systemImage: "bookmark", color: AppTheme.textTertiary)
                            Text("No bookmarked tips yet")
                                .font(.system(size: 15))
                                .foregroundColor(AppTheme.textTertiary)
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                    } else {
                        NavigationLink(destination: BookmarkedTipsView(profile: profile)) {
                            HStack(spacing: 12) {
                                iconBadge(systemImage: "bookmark.fill", color: AppTheme.primary)
                                Text("Bookmarked Tips")
                                    .font(.system(size: 15))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                Text("\(bookmarkedTips.count) saved")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textSecondary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textTertiary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                        }
                    }
                }
                .background(whiteCard)
                .padding(.horizontal, 20)

                // ─── About ───────────────────────────────────────────────
                sectionHeader("About")

                VStack(spacing: 0) {
                    aboutRow(systemImage: "info.circle.fill", iconColor: AppTheme.primary, label: "About BesideHer") {
                        showAbout = true
                    }
                    Divider().padding(.leading, 52)
                    aboutRow(systemImage: "star.fill", iconColor: Color(hex: "F6AD55"), label: "Rate the App") {
                        if let url = URL(string: "https://apps.apple.com/app/id6743770424") {
                            UIApplication.shared.open(url)
                        }
                    }
                    Divider().padding(.leading, 52)
                    aboutRow(systemImage: "envelope.fill", iconColor: Color(hex: "56B89F"), label: "Send Feedback") {
                        if let url = URL(string: "mailto:besideherapp@gmail.com?subject=BesideHer%20Feedback") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .background(whiteCard)
                .padding(.horizontal, 20)

                // ─── Legal ───────────────────────────────────────────────
                sectionHeader("Legal")

                VStack(spacing: 0) {
                    aboutRow(systemImage: "hand.raised.fill", iconColor: Color(hex: "5A8FD6"), label: "Privacy Policy") {
                        showPrivacyPolicy = true
                    }
                    Divider().padding(.leading, 52)
                    aboutRow(systemImage: "doc.text.fill", iconColor: Color(hex: "7A9CC4"), label: "Terms of Use") {
                        showTermsOfUse = true
                    }
                    Divider().padding(.leading, 52)
                    HStack(alignment: .top, spacing: 12) {
                        iconBadge(systemImage: "cross.circle.fill", color: AppTheme.textTertiary)
                        Text("BesideHer is for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always consult your doctor or qualified healthcare provider with any questions about pregnancy.")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textTertiary)
                            .lineSpacing(3)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .background(whiteCard)
                .padding(.horizontal, 20)

                // ─── Version ─────────────────────────────────────────────
                Text("BesideHer v1.0")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textTertiary)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
            .padding(.top, 12)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showGenderPicker) {
            GenderPickerSheet(
                babyGender: profile.babyGender,
                onSave: { newGender in
                    profile.babyGender = newGender
                    showGenderPicker = false
                },
                onCancel: { showGenderPicker = false }
            )
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showTermsOfUse) {
            TermsOfUseView()
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                dueDate: $editedDueDate,
                onSave: {
                    profile.dueDate = editedDueDate
                    if profile.notificationsEnabled {
                        NotificationService.shared.scheduleWeeklyNotifications(dueDate: editedDueDate)
                    }
                    showDatePicker = false
                },
                onCancel: { showDatePicker = false }
            )
        }
    }

    // MARK: - Helper Views

    private func settingsRow(systemImage: String, iconColor: Color, label: String, value: String, showChevron: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                iconBadge(systemImage: systemImage, color: iconColor)
                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textTertiary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .disabled(!showChevron)
    }

    private func aboutRow(systemImage: String, iconColor: Color, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                iconBadge(systemImage: systemImage, color: iconColor)
                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textTertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }

    private func iconBadge(systemImage: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.12))
                .frame(width: 32, height: 32)
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(AppTheme.textTertiary)
                .tracking(0.5)
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private var whiteCard: some View {
        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
            .fill(AppTheme.card)
            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }

    // MARK: - Computed Properties

    private var genderLabel: String {
        switch profile.babyGender {
        case "boy":  return "Boy"
        case "girl": return "Girl"
        default:     return "Unknown"
        }
    }

    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: profile.dueDate)
    }

    private var trimesterLabel: String {
        switch profile.currentTrimester {
        case 1: return "1st Trimester"
        case 2: return "2nd Trimester"
        case 3: return "3rd Trimester"
        default: return "Trimester \(profile.currentTrimester)"
        }
    }


}

// MARK: - Gender Picker Sheet

struct GenderPickerSheet: View {
    @State private var selected: String
    var onSave: (String) -> Void
    var onCancel: () -> Void

    init(babyGender: String, onSave: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        _selected = State(initialValue: babyGender)
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    genderCard(label: "Boy", value: "boy")
                    genderCard(label: "Girl", value: "girl")
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                Button(action: { selected = "unknown" }) {
                    HStack(spacing: 8) {
                        Image(systemName: selected == "unknown" ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selected == "unknown" ? AppTheme.primary : AppTheme.textTertiary)
                        Text("We don't know yet")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()
            }
            .navigationTitle("Baby's Gender")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave(selected) }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func genderCard(label: String, value: String) -> some View {
        let isSelected = selected == value
        return Button(action: { selected = value }) {
            Text(label)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(isSelected ? AppTheme.primary : AppTheme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? AppTheme.primary.opacity(0.08) : AppTheme.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? AppTheme.primary : AppTheme.border,
                                        lineWidth: isSelected ? 2 : 1)
                        )
                )
        }
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var dueDate: Date
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(AppTheme.primary)
                .padding()

                Spacer()
            }
            .navigationTitle("Edit Due Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: onSave)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Bookmarked Tips View

struct BookmarkedTipsView: View {
    let profile: UserProfile
    let content = ContentService.shared

    var bookmarkedTips: [Tip] {
        content.tips(withIDs: profile.bookmarkedTips)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if bookmarkedTips.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 36))
                            .foregroundColor(AppTheme.textTertiary)
                        Text("No bookmarks yet")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Tap the bookmark icon on any tip to save it here.")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                } else {
                    ForEach(bookmarkedTips) { tip in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(tip.title)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                Button(action: {
                                    withAnimation { profile.toggleBookmark(tip.id) }
                                }) {
                                    Image(systemName: "bookmark.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                            Text(tip.content)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                                .lineSpacing(4)
                            Text(tip.categoryDisplayName)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(AppTheme.primary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(AppTheme.primary.opacity(0.1)))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.card)
                                .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Bookmarked Tips")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - About View

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image("BesideHerLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .padding(.horizontal, 32)
                        .padding(.top, 32)

                    VStack(spacing: 8) {
                        Text("Your pregnancy companion for dads")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                            .multilineTextAlignment(.center)
                        Text("Version 1.0")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textTertiary)
                            .padding(.top, 2)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("About the App")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("BesideHer is a pregnancy companion designed for first-time dads. From week-by-week development updates to hospital bag checklists and partner support tips, BesideHer helps you stay engaged, prepared, and present every step of the way.")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(5)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(AppTheme.card)
                            .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)

                    Text("Made for expectant fathers")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textTertiary)
                        .padding(.bottom, 32)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("About BesideHer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Privacy Policy View

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, 8)

                    Text("BesideHer does not collect, store, or share any personal data outside of your device. All information including your due date and preferences is stored locally on your device only. We do not use third-party analytics or advertising.")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineSpacing(5)
                }
                .padding(24)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Terms of Use View

struct TermsOfUseView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Use")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, 8)

                    Text("BesideHer is provided for informational and educational purposes only. The content in this app is not medical advice and should not replace consultation with a qualified healthcare professional. Use of this app is at your own discretion.")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineSpacing(5)
                }
                .padding(24)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Terms of Use")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date())!,
            onboardingCompleted: true,
            notificationsEnabled: true
        ))
    }
}
