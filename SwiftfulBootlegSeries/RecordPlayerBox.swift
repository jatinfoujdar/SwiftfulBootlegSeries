//
//  RecordPlayerBox.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/11/24.
//

import SwiftUI

struct RecordPlayerBox: View {
    var body: some View {
        ZStack{
            Rectangle().frame(width: 340,height: 340).cornerRadius(10.0)
            Image("woodGrain")
                .resizable().frame(width: 325, height: 325)
                .shadow(radius: 3)
        }
    }
}

#Preview {
    RecordPlayerBox()
}
