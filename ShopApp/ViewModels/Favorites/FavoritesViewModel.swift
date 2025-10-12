//
//  FavoritesViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    @Published private(set) var favorites: [Product] = []
    
    // MARK: - Methods
    
    func updateFavorites(_ list: [Product]) {
        favorites = list
    }
    
    func filteredFavorites() -> [Product] {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return favorites }
        let lowercasedText = cleanText.lowercased()
        return favorites.filter {
            $0.name.lowercased()
                .contains(lowercasedText) ||
            $0.description
                .lowercased()
                .contains(lowercasedText)
        }
    }
    
    func remove(_ product: Product, coordinator: AppCoordinator) {
        coordinator.toggleFavorite(product)
        
        updateFavorites(coordinator.appState.favorites)
    }
    
    func selectProduct(_ product: Product, coordinator: AppCoordinator) {
        coordinator.showProductDetail(product)
    }
}
