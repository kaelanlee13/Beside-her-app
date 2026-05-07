//
//  FilterChip.swift
//  BesideHer
//

import SwiftUI

/// Editorial filter chip — ink-filled when active, outlined eyebrow when inactive.
/// Selected: Color.ink background with Color.paper text (warm-black/cream in light, cream/warm-black in dark).
/// Color.ink and Color.paper are inverses in the adaptive theme, guaranteeing AAA contrast in both modes.
/// Unselected: transparent with Color.divider border, inkSecondary eyebrow.
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 10

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.eyebrow)
                .eyebrowStyle()
                .foregroundStyle(isSelected ? Color.paper : Color.inkSecondary)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: Radius.pill, style: .continuous)
                        .fill(isSelected ? Color.ink : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.pill, style: .continuous)
                        .strokeBorder(isSelected ? Color.clear : Color.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isSelected)
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
