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
    }
}

#Preview {
    RecordView(degrees: .constant(2.0), shouldAnimate: .constant(true))
}
