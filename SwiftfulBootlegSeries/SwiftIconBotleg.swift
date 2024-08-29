//
//  SwiftIconBotleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 28/08/24.
//

import SwiftUI

struct SwiftIconBotleg: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .background(.green)
//          .frame(width: 300,height: 300,alignment: .leading)
//            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,alignment: .center)
//            .background(.red)
//            .frame(width: 150)
//            .background(.purple)
//            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .center)
//            .background(.yellow)
//            .frame(height: 400)
//            .background(.green)
//            .frame(maxHeight: .infinity,alignment: .center)
//            .background(.pink)
//        Image(systemName: "heart.fill")
//           .font(.largeTitle)
//              .font(.system(size:50))
//              .foregroundColor(.green)
            .background(
//                LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100, alignment: .center)
            )
            
            .background(
            Circle()
                .fill(Color.red)
                .frame(width: 120, height: 120, alignment: .center)
            )
        
    }
}

#Preview {
    SwiftIconBotleg()
}
