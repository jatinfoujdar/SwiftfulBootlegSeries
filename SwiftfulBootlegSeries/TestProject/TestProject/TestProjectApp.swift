//
//  TestProjectApp.swift
//  TestProject
//
//  Created by jatin foujdar on 03/12/25.
//

import SwiftUI

@main
struct TestProjectApp: App {
    @StateObject var todoManager = TodoListManager()
    var body: some Scene {
        WindowGroup {
            ContentView(todoManager: todoManager)
        }
    }
}
