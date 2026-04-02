//
//  ContentView.swift
//  BesideHer
//
//  Created by Kaelan Lee on 4/2/26.
//

import SwiftUI

struct ContentView: View {
    let content = ContentService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("BesideHer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(content.weeks.count) weeks loaded")
                Text("\(content.tips.count) tips loaded")
                Text("\(content.checklists.count) checklists loaded")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
