//
//  TrimesterGlyph.swift
//  BesideHer
//
//  Three monoline glyphs that rotate by trimester — seed, sprout, full leaf.
//  Replaces the single repeated leaf icon used across the app.
//

import SwiftUI

// MARK: - Trimester

enum Trimester: Int {
    case first = 1, second, third

    init(weekNumber: Int) {
        switch weekNumber {
        case ...13:    self = .first
        case 14...27:  self = .second
        default:       self = .third
        }
    }

    var sfSymbol: String {
        switch self {
        case .first:  return "circle.fill"
        case .second: return "leaf"
        case .third:  return "leaf.fill"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .first:  return "First trimester seed"
        case .second: return "Second trimester sprout"
        case .third:  return "Third trimester leaf"
        }
    }
}

// MARK: - TrimesterGlyph

struct TrimesterGlyph: View {
    let weekNumber: Int
    var size: CGFloat = 24
    var tinted: Bool = false

    private var trimester: Trimester { Trimester(weekNumber: weekNumber) }

    var body: some View {
        let symbol = Image(systemName: trimester.sfSymbol)
            .font(.system(size: size * 0.55, weight: .regular))
            .foregroundStyle(tinted ? Color.accent : Color.inkSecondary)

        return Group {
            if tinted {
                ZStack {
                    Circle()
                        .fill(Color.accentSoft)
                        .frame(width: size, height: size)
                    symbol
                }
            } else {
                symbol
            }
        }
        .accessibilityLabel(trimester.accessibilityLabel)
    }
}

// MARK: - Previews

#Preview("Light mode") {
    TrimesterGlyphShowcase()
        .preferredColorScheme(.light)
}

#Preview("Dark mode") {
    TrimesterGlyphShowcase()
        .preferredColorScheme(.dark)
}

private struct TrimesterGlyphShowcase: View {
    private let sampleWeeks = [6, 20, 34]

    var body: some View {
        ZStack {
            Color.paper.ignoresSafeArea()
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("Tinted")
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.inkSecondary)
                    HStack(spacing: 32) {
                        ForEach(sampleWeeks, id: \.self) { week in
                            TrimesterGlyph(weekNumber: week, size: 56, tinted: true)
                        }
                    }
                }
                VStack(spacing: 12) {
                    Text("Untinted")
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.inkSecondary)
                    HStack(spacing: 32) {
                        ForEach(sampleWeeks, id: \.self) { week in
                            TrimesterGlyph(weekNumber: week, size: 56, tinted: false)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}
