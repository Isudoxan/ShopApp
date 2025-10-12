//
//  SearchBar.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct SearchBar: View {
    
    // MARK: - Properties
    
    @Binding var text: String
    var placeholder: String = "Search"

    // MARK: - Body
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.tertiarySystemFill)))
    }
}
