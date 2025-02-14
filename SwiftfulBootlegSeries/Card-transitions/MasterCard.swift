

import SwiftUI

struct MasterCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.blue)
            .frame(width: 300, height: 150)
            .overlay(
                Text("MasterCard")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title)
            )
    }
}


#Preview {
    MasterCard()
}
