//
//  SearchBar.swift
//  IOSproj
//
//  Created by Rana Tarek on 29/01/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var isDisabled: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search GIFs", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isDisabled) 
        }
        .padding()
        .background(Color(.systemBackground).cornerRadius(10))
        .padding(.horizontal)
    }
}


//#Preview {
//    SearchBar()
//}
