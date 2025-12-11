//
//  ViewModel.swift
//  TestProject
//
//  Created by jatin foujdar on 05/12/25.
//

import Foundation
import Combine
import SwiftUI

class TodoListManager: ObservableObject {
    
    @Published var items: [Item] = [Item(id: UUID(), name: "first", url: "https://www.google.com"),
                                    Item(id:UUID(), name: "second", url: "https://www.apple.com"),
                                    Item(id: UUID(), name: "third", url: "")]
    
    init(){
        
    }
    
    func move(indices: IndexSet, newOffset: Int){
        items.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func addItem(){
    items.append(Item(id: UUID(), name: "newly added", url: ""))
    }
    
    func delete(at indexSet: IndexSet){
        for index in indexSet{
           items.remove(at: index)
        }
    }
    
    static func emptyState() -> TodoListManager{
        let manager = TodoListManager()
        manager.items = []
        return manager
    }
}
