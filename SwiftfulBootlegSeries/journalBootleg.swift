//
//  journalBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 31/08/24.
//

import SwiftUI

struct journalBootleg: View {
    
    var body: some View {
        TabView {
                    ContentView()
                        .tabItem {
                            Label("Journal", systemImage: "book")
                        }
                        
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                   }
               }
           }
#Preview {
    journalBootleg()
}


