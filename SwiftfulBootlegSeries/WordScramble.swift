//
//  WordScramble.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 22/10/24.
//

import SwiftUI

struct WordScramble: View {
     let people = ["Fin","Leia","Luke","Rey"]
    
    var body: some View {
        List(people, id: \.self){
            Text($0)
        }
    }
}

#Preview {
    WordScramble()
}
