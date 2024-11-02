//
//  Stack.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/11/24.
//

import SwiftUI

struct RecordPlayer: View {
    
    @State private var rotateRecored = false
    @State private var rotateArm = false
    @State private var shouldAnimate = false
    @State private var degrees = 0.0
    
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 20, endRadius: 600)
                .scaleEffect(1.2)
            RecordPlayerBox()
        }
       
    }
}

#Preview {
    RecordPlayer()
}
