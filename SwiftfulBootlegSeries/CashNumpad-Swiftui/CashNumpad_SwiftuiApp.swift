//
//  CashNumpad_SwiftuiApp.swift
//  CashNumpad-Swiftui
//
//  Created by jatin foujdar on 14/08/25.
//

import SwiftUI

@main
struct CashNumpad_SwiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            NumpadView()
                .preferredColorScheme(.dark)
        }
    }
}
