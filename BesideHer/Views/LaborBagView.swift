//
//  LaborBagView.swift
//  BesideHer
//
//  Hospital bag packing checklist organized by section
//

import SwiftUI

// MARK: - Model

private struct LaborBagItem: Identifiable {
    let id: String
    let text: String
}

private struct LaborBagSection: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: String
    let items: [LaborBagItem]
}

// MARK: - View

struct LaborBagView: View {
    let profile: UserProfile

    private let sections: [LaborBagSection] = [
        LaborBagSection(id: "mom", title: "For Mom", icon: "🤰", color: "FEF3E6", items: [
            LaborBagItem(id: "lb-m1",  text: "Comfortable robe or nightgown (2–3)"),
            LaborBagItem(id: "lb-m2",  text: "Nursing bra and breast pads (2–3 sets)"),
            LaborBagItem(id: "lb-m3",  text: "Underwear — maternity or disposable (5–6 pairs)"),
            LaborBagItem(id: "lb-m4",  text: "Slip-on shoes or slippers"),
            LaborBagItem(id: "lb-m5",  text: "Going-home outfit (loose, maternity-sized)"),
            LaborBagItem(id: "lb-m6",  text: "Toiletries: shampoo, conditioner, face wash, toothbrush"),
            LaborBagItem(id: "lb-m7",  text: "Hair ties and headband"),
            LaborBagItem(id: "lb-m8",  text: "Lip balm (hospital air is dry)"),
            LaborBagItem(id: "lb-m9",  text: "Phone charger and portable battery"),
            LaborBagItem(id: "lb-m10", text: "Pillow from home (use a colorful case to tell it apart)"),
            LaborBagItem(id: "lb-m11", text: "Snacks and drinks for labor"),
            LaborBagItem(id: "lb-m12", text: "Entertainment: tablet, books, or headphones"),
            LaborBagItem(id: "lb-m13", text: "Glasses if she wears contacts"),
        ]),
        LaborBagSection(id: "baby", title: "For Baby", icon: "👶", color: "E8F0FE", items: [
            LaborBagItem(id: "lb-b1", text: "Going-home outfit (newborn AND 0–3 month sizes)"),
            LaborBagItem(id: "lb-b2", text: "Infant car seat — installed before you leave"),
            LaborBagItem(id: "lb-b3", text: "Swaddle blanket (1–2)"),
            LaborBagItem(id: "lb-b4", text: "Newborn hat and socks"),
            LaborBagItem(id: "lb-b5", text: "Diapers and wipes (hospital usually provides, but bring a pack)"),
        ]),
        LaborBagSection(id: "dad", title: "For Dad", icon: "💪", color: "E6F7F2", items: [
            LaborBagItem(id: "lb-d1", text: "Change of clothes for 2–3 days"),
            LaborBagItem(id: "lb-d2", text: "Toiletries and deodorant"),
            LaborBagItem(id: "lb-d3", text: "Phone charger and camera"),
            LaborBagItem(id: "lb-d4", text: "Snacks and cash for vending machines"),
            LaborBagItem(id: "lb-d5", text: "Pillow or small blanket for sleeping in the room"),
            LaborBagItem(id: "lb-d6", text: "List of people to call or text after birth"),
            LaborBagItem(id: "lb-d7", text: "Entertainment for long labor (book, tablet, headphones)"),
            LaborBagItem(id: "lb-d8", text: "Comfortable shoes — you'll be on your feet a lot"),
        ]),
        LaborBagSection(id: "docs", title: "Documents", icon: "📋", color: "F3EEF9", items: [
            LaborBagItem(id: "lb-doc1", text: "Health insurance card"),
            LaborBagItem(id: "lb-doc2", text: "Hospital pre-registration confirmation"),
            LaborBagItem(id: "lb-doc3", text: "OB or midwife contact numbers"),
            LaborBagItem(id: "lb-doc4", text: "Birth plan — printed, 3 copies"),
            LaborBagItem(id: "lb-doc5", text: "Photo ID and any hospital intake forms"),
            LaborBagItem(id: "lb-doc6", text: "Pediatrician's name and number"),
        ]),
    ]

    private var allItems: [LaborBagItem] { sections.flatMap(\.items) }
    private var completedCount: Int { allItems.filter { profile.isChecklistItemCompleted($0.id) }.count }
    private var totalCount: Int { allItems.count }
    private var progress: Double { totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                progressCard
                    .padding(.top, 8)

                ForEach(sections) { section in
                    sectionCard(section)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.paper)
        .navigationTitle("Hospital Bag")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Progress Card

    private var progressCard: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Packing Progress")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "1A2B42"))
                Spacer()
                Text("\(completedCount) of \(totalCount)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "3B7DD8"))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "E8F0FE"))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "3B7DD8"))
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 6)

            if completedCount == totalCount && totalCount > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "56B89F"))
                        .font(.system(size: 13))
                    Text("Bag is packed — you're ready!")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "56B89F"))
                }
                .padding(.top, 2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surface)
                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
        )
    }

    // MARK: - Section Card

    private func sectionCard(_ section: LaborBagSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: section.color))
                        .frame(width: 30, height: 30)
                    Text(section.icon)
                        .font(.system(size: 15))
                }
                Text(section.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1A2B42"))

                Spacer()

                let done = section.items.filter { profile.isChecklistItemCompleted($0.id) }.count
                Text("\(done)/\(section.items.count)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "8E9BAD"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()
                .padding(.horizontal, 16)

            // Items
            ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0) {
                    if index > 0 {
                        Divider()
                            .padding(.leading, 50)
                    }

                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                profile.toggleChecklistItem(item.id)
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(profile.isChecklistItemCompleted(item.id) ? Color(hex: "3B7DD8") : .clear)
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(
                                                profile.isChecklistItemCompleted(item.id) ? Color.clear : Color(hex: "E4EAF1"),
                                                lineWidth: 1.5
                                            )
                                    )

                                if profile.isChecklistItemCompleted(item.id) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }

                        Text(item.text)
                            .font(.system(size: 14))
                            .foregroundColor(profile.isChecklistItemCompleted(item.id) ? Color(hex: "8E9BAD") : Color(hex: "1A2B42"))
                            .strikethrough(profile.isChecklistItemCompleted(item.id))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.surface)
                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "E4EAF1"), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        LaborBagView(profile: UserProfile(
            dueDate: Calendar.current.date(byAdding: .weekOfYear, value: 8, to: Date())!,
            onboardingCompleted: true
        ))
    }
}
