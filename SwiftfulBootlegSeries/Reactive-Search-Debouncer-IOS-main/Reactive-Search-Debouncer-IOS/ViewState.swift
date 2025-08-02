//
//  ViewState.swift
//  Reactive-Search-Debouncer-IOS
//
//  Created by jatin foujdar on 20/07/25.
//

enum ViewState<T>{
    case idle
    case loading
    case data(T)
    
    var isLoading: Bool{
        if case .loading = self {
            return true
        }
        return false
    }
    
    var data: T? {
        if case .data(let t) = self {
            return t
        }
        return nil
    }
}
