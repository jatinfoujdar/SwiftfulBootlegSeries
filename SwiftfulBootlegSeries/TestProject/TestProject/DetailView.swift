//
//  DetailView.swift
//  TestProject
//
//  Created by onegravity on 12/12/25.
//

import SwiftUI

struct DetailView: View {
    @Binding var item: Item
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $item.name)
                TextField("URL", text: $item.url)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
        }
        .navigationTitle("Edit Item")
    }
}
