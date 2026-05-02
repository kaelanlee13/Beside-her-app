//
//  HairlineProgressRuler.swift
//  BesideHer
//

import SwiftUI

/// A 1pt editorial progress ruler with optional trimester (or any) tick marks above the line.
///
/// Usage:
///   HairlineProgressRuler(progress: 0.65, ticks: [1/3, 2/3])
struct HairlineProgressRuler: View {
    let progress: Double
    var ticks: [Double] = []

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            VStack(alignment: .leading, spacing: 2) {
                // Tick mark row (4pt tall)
                ZStack(alignment: .bottomLeading) {
                    Color.clear
                    ForEach(Array(ticks.enumerated()), id: \.offset) { _, t in
                        Rectangle()
                            .fill(Color.divider)
                            .frame(width: 1, height: 4)
                            .offset(x: w * t)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 4)

                // Progress line (1pt tall)
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.divider)
                    Rectangle()
                        .fill(Color.accent)
                        .frame(width: w * clamped)
                        .animation(.easeInOut(duration: 1.2), value: clamped)
                }
                .frame(maxWidth: .infinity, maxHeight: 1)
            }
        }
        .frame(height: 7) // 4pt ticks + 2pt gap + 1pt line
    }
}

#Preview {
    VStack(spacing: 32) {
        VStack(alignment: .leading, spacing: 8) {
            Text("37 / 40 weeks — with trimester ticks")
                .font(.caption)
            HairlineProgressRuler(progress: 37.0 / 40.0, ticks: [13.0 / 40.0, 27.0 / 40.0])
        }
        VStack(alignment: .leading, spacing: 8) {
            Text("50% — no ticks")
                .font(.caption)
            HairlineProgressRuler(progress: 0.5)
        }
        VStack(alignment: .leading, spacing: 8) {
            Text("100% complete")
                .font(.caption)
            HairlineProgressRuler(progress: 1.0, ticks: [0.25, 0.5, 0.75])
        }
    }
    .padding(24)
    .background(Color.surface)
}
