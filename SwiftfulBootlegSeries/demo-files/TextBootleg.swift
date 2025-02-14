//  TextBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 28/08/24.
//

import SwiftUI

struct TextBootleg: View {
    var body: some View {
//        Text("Hello, World!")
//            .font(.title)
//            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//            .italic()
//            .strikethrough(true, color: Color.blue)
//            .underline(true, color: Color.yellow)
//            .foregroundColor(Color.red)
//  .multilineTextAlignment(.center)
//    Circle()
//            .fill(Color.blue)
//            .foregroundColor(.pink)
//            .stroke(Color.blue, lineWidth:30)
        VStack {
                    MyControls(label: "Mini")
                        .controlSize(.mini)
                    MyControls(label: "Small")
                        .controlSize(.small)
                    MyControls(label: "Regular")
                        .controlSize(.regular)
                }
                .padding()
               
                .border(Color.gray)
        
    }
}
struct MyControls: View {
    var label: String
    @State private var value = 3.0
    @State private var selected = 1
    var body: some View {
        HStack {
            Text(label + ":")
            Picker("Selection", selection: $selected) {
                Text("option 1").tag(1)
                Text("option 2").tag(2)
                Text("option 3").tag(3)
            }
            Slider(value: $value, in: 1...10)
            Button("OK") { }
        }
    }
}

#Preview {
    TextBootleg()
}
