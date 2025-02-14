import SwiftUI
import Foundation

struct CardDetails {
    var icon: String
    var title: String
    var money: String
    var date: String
    var time: String
}


struct CardTransitions: View {
    var cards: [CardDetails] = [
          CardDetails(icon: "💳", title: "Payment to Store A", money: "$45.67", date: "2025-02-13", time: "14:23"),
          CardDetails(icon: "🛍️", title: "Shopping at Mall B", money: "$120.99", date: "2025-02-12", time: "09:30"),
          CardDetails(icon: "🍕", title: "Food Order - Pizza Hut", money: "$25.49", date: "2025-02-11", time: "18:45"),
          CardDetails(icon: "🚕", title: "Taxi Fare", money: "$15.80", date: "2025-02-14", time: "07:58"),
          CardDetails(icon: "🏦", title: "Bank Deposit", money: "$300.00", date: "2025-02-14", time: "10:00"),
          CardDetails(icon: "🎮", title: "Video Game Purchase", money: "$59.99", date: "2025-02-10", time: "20:02"),
          CardDetails(icon: "☕", title: "Coffee at Café C", money: "$4.75", date: "2025-02-13", time: "15:00")
      ]
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
