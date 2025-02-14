//
//  GredContainers.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 08/10/24.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows : Int
    let columns: Int
    let content: (Int, Int)-> Content
    
    var body: some View{
        VStack{
            ForEach(0..<rows, id: \.self){ row in
                HStack{
                    ForEach(0..<columns, id: \.self){column in
                        content(row,column)
                    }
                }
            }
        }
    }
}

struct GredContainers: View {
    var body: some View {
        GridStack(rows:4,columns: 4){row , col in
            Text("R\(row) C\(col)")
        }
    }
}

#Preview {
    GredContainers()
}
