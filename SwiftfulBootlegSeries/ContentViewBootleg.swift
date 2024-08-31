//
//  ContentViewBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 31/08/24.
//

import SwiftUI

struct ContentViewBootleg: View {
    var body: some View {
        VStack{
            MapBootleg()
                .frame(height:300)
            VStack(alignment: .leading, content: {
                Text("Turtle Rock")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HStack{
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                        Spacer()
                      Text("California")
                    .font(.subheadline)
                }
                Divider()



                                Text("About Turtle Rock")

                                    .font(.title2)

                                Text("Descriptive text goes here.")
            }
            )
            .padding()
        }
    }
}

#Preview {
    ContentViewBootleg()
}
