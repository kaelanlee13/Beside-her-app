//
//  FilterChip.swift
//  BesideHer
//

import SwiftUI

/// Quiet editorial filter chip.
/// Selected: Color.ink background with Color.paper text — strong contrast in both modes.
/// Unselected: transparent with Color.divider border.
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var horizontalPadding: CGFloat = 14
    var verticalPadding: CGFloat = 8

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.eyebrow)
                .textCase(.uppercase)
                .tracking(1.4)
                .foregroundStyle(isSelected ? Color.paper : Color.inkSecondary)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.ink : Color.clear)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.clear : Color.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 8) {
            FilterChip(title: "1st Tri", isSelected: true,  action: {})
            FilterChip(title: "2nd Tri", isSelected: false, action: {})
            FilterChip(title: "3rd Tri", isSelected: false, action: {})
            FilterChip(title: "Ongoing", isSelected: false, action: {})
        }
        HStack(spacing: 8) {
            FilterChip(title: "All",      isSelected: false, action: {},
                       horizontalPadding: 14, verticalPadding: 8)
            FilterChip(title: "Medical",  isSelected: true,  action: {},
                       horizontalPadding: 14, verticalPadding: 8)
            FilterChip(title: "Practical", isSelected: false, action: {},
                       horizontalPadding: 14, verticalPadding: 8)
        }
    }
    .padding(24)
    .background(Color.paper)
}
