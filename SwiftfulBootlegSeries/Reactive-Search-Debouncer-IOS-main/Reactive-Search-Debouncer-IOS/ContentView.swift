//
//  ContentView.swift
//  Reactive-Search-Debouncer-IOS
//
//  Created by jatin foujdar on 19/07/25.
//

import SwiftUI


struct ContentView: View {

    @State var vm = ViewModel()

    

    var body: some View {

        List(vm.state.data ?? [], id: \.self) {
            Text($0)
        }
        .overlay {
            if vm.state.isLoading {
                ProgressView("Searching \"\(vm.searchText)\"")
            }

            if vm.isSearchNotFound {

                Text("Results not found for\n\"\(vm.searchText)\"")
                    .multilineTextAlignment(.center)
            }
        }

    }

}

#Preview {
    ContentView()
}
