//
//  SwiftUIView.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 11/10/24.
//

import SwiftUI

struct Scrumdinger: View {
    var body: some View {
        VStack {
            ProgressView(value: 10, total: 15)
            HStack{
                VStack {
                    Text("Seconds Ellapsed")
                    Label("300", systemImage: "hourglass.tophalf.fill")
                }
                VStack {
                    Text("Seconds Remaining")
                    Label("600", systemImage: "hourglass.tophalf.fill")
                }
            }
        }
    }
}

#Preview {
    Scrumdinger()
}
