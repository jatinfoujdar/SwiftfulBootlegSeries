//
//  ContentView.swift
//  TrafficLight
//
//  Created by jatin foujdar on 23/08/25.
//

import SwiftUI

enum TrafficLightState{
    case red, yellow, green
}

struct ContentView: View {
    @State private var currentLight : TrafficLightState = .green
    var body: some View {
        VStack {
          Circle()
                .fill(currentLight == .red ? Color.red : Color.red.opacity(0.3) )
                .frame(width: 100, height: 100)
            
            Circle()
                .fill(currentLight == .yellow ? Color.yellow : Color.yellow.opacity(0.3))
                  .frame(width: 100, height: 100)
            
            Circle()
                .fill(currentLight == .green ? Color.green : Color.green.opacity(0.3))
                  .frame(width: 100, height: 100)
        }
        .padding()
        .background(.black)
        .cornerRadius(20)
        .shadow(radius: 10)
        .onAppear{
            startCycle()
        }
    }
    
    
    private func startCycle(){
        switch currentLight {
        case .green: DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            withAnimation{
                currentLight = .yellow
            }
            startCycle()
        }
            
        case .yellow : DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            withAnimation{
                currentLight = .red
            }
            startCycle()
        }
            
        case .red: DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
            withAnimation{
                currentLight = .green
            }
            startCycle()
        }
        }
    }
}

#Preview {
    ContentView()
}



