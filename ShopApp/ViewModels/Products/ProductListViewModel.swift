//
//  ProductListViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    @Published private(set) var products: [Product] = []

    var filteredProducts: [Product] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanSearchText.isEmpty { return products }
        let lowerCasedText = cleanSearchText.lowercased()
        return products.filter { $0.name.lowercased().contains(lowerCasedText) || $0.description.lowercased().contains(lowerCasedText) }
    }
    
    // MARK: - Lifecycle
    
    init(products: [Product]) {
        self.products = products
    }
}
