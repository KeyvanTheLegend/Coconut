//
//  SerachBar.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/1/21.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $searchText)
                .padding(8)
                .padding(.horizontal, 4)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.isEditing = true
                }
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.hideKeyboard()
                    self.searchText = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 16)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.default)
    }
}
