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
            .background(.green)
//            .frame(width: 300,height: 300,alignment: .leading)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,alignment: .center)
            .background(.red)
            .frame(width: 150)
            .background(.purple)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .center)
            .background(.yellow)
            .frame(height: 400)
            .background(.green)
            .frame(maxHeight: .infinity,alignment: .center)
            .background(.pink)
//        Image(systemName: "heart.fill")
//           .font(.largeTitle)
//              .font(.system(size:50))
//              .foregroundColor(.green)
        
        
    }
}

#Preview {
    SwiftIconBotleg()
}
