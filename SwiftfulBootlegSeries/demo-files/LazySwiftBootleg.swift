//
//  LazySwiftBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/09/24.
//

import SwiftUI

struct LazySwiftBootleg: View {
    var body: some View {
        let columns: [GridItem] = [
                  GridItem(.flexible(), spacing: nil, alignment: nil),
                  GridItem(.flexible(), spacing: nil, alignment: nil),
                  GridItem(.flexible(), spacing: nil, alignment: nil),
                  
              ]
        ScrollView{
            Rectangle()
                .fill(.white)
                .frame(height: 400)
            
            LazyVGrid(columns: columns) {
               
                ForEach(0..<50){
                    index in
                    Rectangle()
                        .frame(height: 150)
                }
        }
            .padding()
               }
           }
       }

#Preview {
    LazySwiftBootleg()
}
