//
//  StackBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 29/08/24.
//

import SwiftUI

struct StackBootleg: View {
    var body: some View {
//        Text("Hello, World!")
//     HStack ZStack   VStack{
//            Rectangle()
//                .fill(.red)
//                .frame(width:100 ,height: 100)
//            
//            Rectangle()
//                .fill(.green)
//                .frame(width:100 ,height: 100)
//            
//            Rectangle()
//                .fill(.orange)
//                .frame(width:100 ,height: 100)
//        }
//            .padding(.all, 10)
//            .background(.blue)
//            .padding(.vertical,50)
//        Text("dasddaaavdsvsvs")
          
        HStack(spacing:0){
            
            Image(systemName: "xmark")
            Spacer()
            Image(systemName:"gear")
              
        }
        .font(.title)
        .background(.yellow)
        .padding(.horizontal)
            .background(.red)
        
    }
}

#Preview {
    StackBootleg()
}
