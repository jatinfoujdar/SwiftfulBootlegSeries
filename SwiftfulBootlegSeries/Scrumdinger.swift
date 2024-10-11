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
                Text("Seconds Ellapsed")
            }
        }
    }
}

#Preview {
    Scrumdinger()
}
