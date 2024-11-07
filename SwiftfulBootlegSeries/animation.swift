//
//  animation.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 07/11/24.
//

import SwiftUI

struct animation: View {
    @State private var tap = 1.0
    var body: some View {
        Button("Tap me"){
            tap = (tap == 1.0) ? 1.5 : 1.0
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(tap)
        .animation(.easeInOut(duration: 0.3), value: tap)
    }
    
    
}

#Preview {
    animation()
}
