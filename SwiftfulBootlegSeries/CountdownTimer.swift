//
//  CountdownTimer.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 18/10/24.
//

import SwiftUI

struct CountdownTimer: View {
    @State private var timeRemaining = 60
    @State private var timerIsPaused = true
    @State private var timer: Timer? = nil
    var body: some View {
        VStack{
            Text("\(timeString(time: timeRemaining))")
        }
    }
}
func timeString(time: Int){
    
}

#Preview {
    CountdownTimer()
}
