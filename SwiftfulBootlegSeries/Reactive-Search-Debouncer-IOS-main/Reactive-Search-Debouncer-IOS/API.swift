//
//  API.swift
//  Reactive-Search-Debouncer-IOS
//
//  Created by jatin foujdar on 22/07/25.
//

import Foundation


class API {

    func search(text: String) async throws -> [String] {

        print("\(Date()) -> API: searching for \(text)") 

        try await Task.sleep(for: .milliseconds((400...800).randomElement()!))
        
        try Task.checkCancellation()

        return Self.stubs
            .filter( {$0.localizedCaseInsensitiveContains(text) })
    }

    static let stubs =
        [
            "Spider-Man",
            "Iron Man",
            "Captain America",
            "Howard the Duck"
        ].sorted(using: .localizedStandard)
}
