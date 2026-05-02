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
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.bodyText.weight(.semibold))
                    }
                    .foregroundStyle(Color.accent)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()

            Text("STEP 3 OF 4")
                .font(.eyebrow)
                .textCase(.uppercase)
                .tracking(1.4)
                .foregroundStyle(Color.accent)
                .padding(.bottom, 8)

            Text("Do you know the\nbaby's gender?")
                .font(.h1)
                .foregroundStyle(Color.ink)
                .multilineTextAlignment(.center)

            Text("This helps us personalize\nyour experience.")
                .font(.bodyText)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 36)

            HStack(spacing: 16) {
                genderCard(label: "Boy", value: "boy")
                genderCard(label: "Girl", value: "girl")
            }
            .padding(.horizontal, 24)

            Button(action: { babyGender = "unknown" }) {
                HStack(spacing: 8) {
                    Image(systemName: babyGender == "unknown" ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(babyGender == "unknown" ? Color.accent : Color.inkSecondary)
                    Text("We don't know yet")
                        .font(.bodyText.weight(.medium))
                        .foregroundStyle(Color.inkSecondary)
                }
                .padding(.top, 20)
            }

            Spacer()

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color.accent)
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color.divider)
                    .frame(width: 10, height: 4)
            }
            .padding(.bottom, 32)

            Button(action: onContinue) {
                Text("Continue")
                    .font(.bodyText.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.accent)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }

    private func genderCard(label: String, value: String) -> some View {
        let isSelected = babyGender == value

        return Button(action: { babyGender = value }) {
            VStack(spacing: 12) {
                Text(label)
                    .font(.h2)
                    .foregroundStyle(isSelected ? Color.accent : Color.ink)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentSoft : Color.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.accent : Color.divider,
                                    lineWidth: isSelected ? 2 : 1)
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
