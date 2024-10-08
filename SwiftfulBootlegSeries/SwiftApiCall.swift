//
//  SwiftApiCall.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 08/10/24.
//

import SwiftUI

struct SwiftApiCall: View {
    var body: some View {
        VStack(spacing: 20){
            Circle()
                .foregroundStyle(.gray)
                .frame(width: 120,height: 120)
            Text("Username")
                .bold()
                .font(.title3)
            Text("this is where Bio will go. Lets make it long so that span will open in two line ")
                .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SwiftApiCall()
}
