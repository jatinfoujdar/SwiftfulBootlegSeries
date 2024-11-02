//
//  ArmView.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/11/24.
//

import SwiftUI

struct ArmView: View {
    @Binding var rotateArm: Bool
    var body: some View {
        
        Image("playerArm")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .rotationEffect(Angle.degrees(-35),anchor: .topTrailing)
            .rotationEffect(Angle.degrees(rotateArm ? 8 : 0),anchor: .topTrailing)
            .animation(Animation.linear(duration: 2))
            
    }
}

#Preview {
    ArmView(rotateArm: .constant(true))
}
