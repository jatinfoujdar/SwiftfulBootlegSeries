//
//  ContentView.swift
//  TestProject
//
//  Created by jatin foujdar on 03/12/25.
//

import SwiftUI
import Combine



struct ContentView: View {

    @ObservedObject var todoManager: TodoListManager
    
       
    var body: some View {
        NavigationView{
            List{
                ForEach($todoManager.items) { $item in
                    NavigationLink(destination: DetailView(item: $item), label: {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            if !item.url.isEmpty {
                                Text(item.url)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    })
                }
                .onDelete(perform: { indexSet in
                    todoManager.delete(at: indexSet)
                })
                .onMove(perform: {indices, newOffset in
                    todoManager.move(indices: indices, newOffset: newOffset)
                })
            }
            .navigationBarTitle(Text("Todo's"), displayMode: .large)
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    EditButton()
                    Button(action:{
                        todoManager.addItem()
                    } , label:{
                        Image(systemName: "plus")
                    })
                }
            })
        }
    }
}

#Preview {
    ContentView(todoManager: TodoListManager())
}
