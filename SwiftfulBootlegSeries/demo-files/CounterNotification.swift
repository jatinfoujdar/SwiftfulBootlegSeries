//
//  CounterView.swift
//  colorChange
//
//  Created by jatin foujdar on 29/05/25.
//
import SwiftUI
import UserNotifications

struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Button("Increment") {
                count += 1
                SendNotification(for: count)
            }

            Text("Counter \(count)")
        }
        .onAppear {
            requestPermissionNotification()
        }
    }

    func requestPermissionNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }

    func SendNotification(for count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Counter Update"
        content.body = "New count is \(count)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
}
#Preview {
    CounterView()
}
