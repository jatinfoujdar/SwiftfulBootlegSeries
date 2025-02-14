//
//  RecordView.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 02/11/24.
//

import SwiftUI


struct RecordView: View {
    @Binding var degrees : Double
    @Binding var shouldAnimate : Bool
    var body: some View {
        Image("record")
            .resizable()
            .frame(width: 275, height: 275)
            .rotationEffect(Angle.degrees(degrees))
//            .animation(Animation.linear(duration: shouldAnimate ? 60 : 0).delay(1.5))
    }
}

#Preview {
    RecordView(degrees: .constant(2.0), shouldAnimate: .constant(true))
}
