//
//  ScrollViewBootleg .swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/09/24.
//

import SwiftUI

struct ScrollViewBootleg_: View {
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false, content:{
//            HStack{
//                ForEach(0..<50){ index in
//                    Rectangle()
//                        .fill(.blue)
//                        .frame(width: 200,height: 300)
//                }
//            }
//        })
        ScrollView{
            //LazyStack
            VStack{
        ForEach(0..<10){index in
            ScrollView(.horizontal,showsIndicators: false,content:{
                
                HStack {
                    ForEach(0..<20){index in
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(.red)
                            .frame(width: 200, height: 150)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding()
                    }
                   
                }
            
                    })
               
                }
            }
        }
        
    }
}

#Preview {
    ScrollViewBootleg_()
}
