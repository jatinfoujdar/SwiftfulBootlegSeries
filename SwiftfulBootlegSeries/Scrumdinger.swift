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
            ProgressView(value: 5, total: 15)
            HStack{
                VStack(alignment: .leading){
                    Text("Seconds Ellapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.tophalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("Seconds Remaining")
                        .font(.caption)
                    Label("600", systemImage: "hourglass.tophalf.fill")
                }
            }
            Circle()
                .strokeBorder(lineWidth: 24)
        }
    }
}

#Preview {
    Scrumdinger()
}
