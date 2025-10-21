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
    @Published private(set) var favoriteItems: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    
    var total: Double {
        favoriteItems.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - Lifecycle
    
    func setup(coordinator: AppCoordinator) {
        coordinator.$favoriteItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favs in
                guard let self = self else { return }
                self.favoriteItems = favs
                log.info("Favorites updated. Total favorite items: \(favs.count).")
            }
            .store(in: &cancellables)
        log.info("FavoritesViewModel setup complete.")
    }
    
    // MARK: - Methods
    
    func filteredFavorites() -> [Product] {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            log.info("Filtered favorites requested with empty search — returning all (\(favoriteItems.count)).")
            return favoriteItems
        }
        let lowercasedText = cleanText.lowercased()
        let filtered = favoriteItems.filter {
            $0.name.lowercased().contains(lowercasedText) ||
            $0.description.lowercased().contains(lowercasedText)
        }
        log.info("Filtered favorites with query '\(cleanText)': \(filtered.count) found.")
        return filtered
    }
    
    func remove(_ product: Product, coordinator: AppCoordinator) {
        coordinator.toggleFavorite(product)
        log.info("Removed product from favorites: \(product.name)")
    }
    
    func selectProduct(_ product: Product, coordinator: AppCoordinator) {
        coordinator.showProductDetail(product)
        log.info("Selected product: \(product.name)")
    }
}
