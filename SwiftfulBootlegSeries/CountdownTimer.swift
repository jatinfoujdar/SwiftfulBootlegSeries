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
        HStack{
            Button(action: startTimer){
                Text("Start")
            }
            Spacer()
            Button(action: resetTimer){
                Text("Reset")
            }
        }
        .padding(40)
    }
}
func timeString(time: Int) -> String{
    let minutes = time / 60
    let seconds = time % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

func startTimer(){
    
}
func resetTimer(){
    
}

#Preview {
    CountdownTimer()
}
