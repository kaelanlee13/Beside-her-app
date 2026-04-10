//
//  DueDateView.swift
//  BesideHer
//
//  Onboarding Step 2: Due date picker
//

import SwiftUI

struct DueDateView: View {
    @Binding var dueDate: Date
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
            Text("STEP 2 OF 4")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "3B7DD8"))
                .tracking(1)
                .padding(.bottom, 8)
            
            // Title
            Text("When is the\ndue date?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "1A2B42"))
                .multilineTextAlignment(.center)
            
            // Description
            Text("We'll calculate which week you're in\nand personalize your content.")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "5A6B80"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 24)
            
            // Date picker
            DatePicker(
                "Due Date",
                selection: $dueDate,
                in: Date()...Calendar.current.date(byAdding: .month, value: 10, to: Date())!,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color(hex: "3B7DD8"))
            .frame(height: 360)
            .clipped()
            .padding(.horizontal, 24)
            .transaction { $0.animation = nil }
            
            Spacer()
            
            // Page indicator
            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
                Capsule()
                    .fill(Color(hex: "3B7DD8"))
                    .frame(width: 24, height: 4)
                Capsule()
                    .fill(Color(hex: "E4EAF1"))
                    .frame(width: 10, height: 4)
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
}

#Preview {
    DueDateView(
        dueDate: .constant(Date()),
        onContinue: {},
        onBack: {}
    )
}
