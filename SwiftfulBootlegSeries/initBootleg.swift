//
//  initBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 30/08/24.
//

import SwiftUI

struct initBootleg: View {
    
    let backgroundColor: Color = Color.blue
    
    var body: some View {
        VStack {
            Text("5")
                .font(.largeTitle)
                .foregroundColor(.white)
                .underline()
            Text("Apples")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150,height: 150)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    initBootleg()
}
