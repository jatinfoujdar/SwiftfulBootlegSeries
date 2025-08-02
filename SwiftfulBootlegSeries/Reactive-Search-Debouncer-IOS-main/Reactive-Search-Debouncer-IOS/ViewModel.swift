//
//  ViewModel.swift
//  Reactive-Search-Debouncer-IOS
//
//  Created by jatin foujdar on 21/07/25.
//
import Combine
import Observation
import Foundation

@MainActor
@Observable class ViewModel {
    
    @MainActor

    @Observable class ViewModel {

        @ObservationIgnored var searchTextSubject = CurrentValueSubject<String, Never>("")
        @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    
        
        var searchText = "" {
            didSet {
                searchTextSubject.send(searchText)
            }
        }
        
    var state = ViewState<[String]>.idle
    var searchTask: Task<Void, Never>?
    let api = API()

        init() {

            searchTextSubject
                .filter { $0.isEmpty } // Only care if text is empty
                .sink { [weak self] _ in // What to do when it's empty
                    guard let self else { return }
                    self.searchTask?.cancel() // Stop any ongoing search
                    self.displayIdleState() // Show the default items
                }.store(in: &cancellables) // Keep this connection alive
            // 2. Set up the debouncer for actual searches
            searchTextSubject
                .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main) // Wait for 1 second pause
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } // Ignore empty text after debounce
                .sink { [weak self] text in // What to do when debounced text arrives
                    guard let self else { return }
                    self.searchTask?.cancel() // Cancel any previous search
                    self.searchTask = createSearchTask(text) // Start a new search
                }
                .store(in: &cancellables) // Keep this connection alive
        }

    func displayIdleState() {
        state = .data(API.stubs)
    }

    func createSearchTask(_ text: String) {
  
        searchTask?.cancel()

        searchTask = Task {
            do {
                self.state = .loading

                // try await Task.sleep(nanoseconds: 300_000_000) // 300ms

                try Task.checkCancellation()

                let data = try await api.search(text: text)

                try Task.checkCancellation()

                self.state = .data(data)
            } catch {
                if error is CancellationError {
                    print("Search cancelled")
                } else {
                    print("Search failed: \(error.localizedDescription)")
                    // Optionally set state = .error(error)
                }
            }
        }
    }
}
