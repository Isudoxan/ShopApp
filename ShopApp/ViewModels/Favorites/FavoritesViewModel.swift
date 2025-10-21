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
    @Published var selectedProduct: Product?
    @Published var showProductDetail: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: AppCoordinator!
    
    var total: Double {
        favoriteItems.reduce(0) { $0 + $1.price }
    }
    
    var filteredFavorites: [Product] {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return favoriteItems }
        let lower = cleanText.lowercased()
        return favoriteItems.filter {
            $0.name.lowercased().contains(lower) || $0.description.lowercased().contains(lower)
        }
    }
    
    // MARK: - Setup
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        
        self.favoriteItems = coordinator.favoriteItems
        log.info("FavoritesViewModel setup complete. Initial count: \(favoriteItems.count)")
        
        coordinator.$favoriteItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favs in
                self?.favoriteItems = favs
                log.info("Favorites updated: \(favs.count) items.")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func remove(_ product: Product) {
        coordinator.toggleFavorite(product)
        log.info("Removed from favorites: \(product.name)")
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
        showProductDetail = true
        log.info("Selected favorite product: \(product.name)")
    }
}
