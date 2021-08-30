//
//  SearchBar.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 30/08/21.
//

import SwiftUI

struct Searchbar: View {
    
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text).padding(7).padding(.horizontal, 25).cornerRadius(8)
                .padding(.horizontal, 10).onTapGesture {
                    self.isEditing = true
                }
                
                
            Image(systemName: "magnifyingglass").padding(.trailing)
        }
    }
}

struct Searchbar_Previews: PreviewProvider {
    static var previews: some View {
        Searchbar(text: .constant(""))
    }
}
