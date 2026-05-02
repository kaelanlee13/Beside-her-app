//
//  GenderView.swift
//  BesideHer
//
//  Onboarding Step 3: Baby gender selection
//

import SwiftUI

struct GenderView: View {
    @Binding var babyGender: String
    var onContinue: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "3B7DD8"))
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()

            // Step label
            Text("STEP 3 OF 4")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "3B7DD8"))
                .tracking(1)
                .padding(.bottom, 8)

            // Title
            Text("Do you know the\nbaby's gender?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
                .multilineTextAlignment(.center)

            // Description
            Text("This helps us personalize\nyour experience.")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 36)

            // Gender selection cards
            HStack(spacing: 16) {
                genderCard(label: "Boy", value: "boy")
                genderCard(label: "Girl", value: "girl")
            }
            .padding(.horizontal, 24)

            // Don't know yet option
            Button(action: { babyGender = "unknown" }) {
                HStack(spacing: 8) {
                    if babyGender == "unknown" {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "3B7DD8"))
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(Color(hex: "C0CDD8"))
                    }
                    Text("We don't know yet")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "5A6B80"))
                }
                .padding(.top, 20)
            }

            Spacer()

            // Page indicator
            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "3B7DD8"))
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
            }
            .padding(.bottom, 32)

            // Continue button
            Button(action: onContinue) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "3B7DD8"))
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }

    private func genderCard(label: String, value: String) -> some View {
        let isSelected = babyGender == value
        let fillColor = isSelected ? Color(hex: "EBF2FD") : Color.surface
        let strokeColor = isSelected ? Color(hex: "3B7DD8") : Color(hex: "E4EAF1")
        let strokeWidth: CGFloat = isSelected ? 2 : 1
        let labelColor = isSelected ? Color(hex: "3B7DD8") : Color(hex: "1A2B42")

        return Button(action: { babyGender = value }) {
            VStack(spacing: 12) {
                Text(label)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(labelColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(fillColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(strokeColor, lineWidth: strokeWidth)
                    )
            )
        }
    }
}

#Preview {
    GenderView(
        babyGender: .constant("unknown"),
        onContinue: {},
        onBack: {}
    )
}
