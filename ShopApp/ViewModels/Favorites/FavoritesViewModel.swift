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
                self?.favoriteItems = favs
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func filteredFavorites() -> [Product] {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return favoriteItems }
        let lowercasedText = cleanText.lowercased()
        return favoriteItems.filter {
            $0.name.lowercased().contains(lowercasedText) ||
            $0.description.lowercased().contains(lowercasedText)
        }
    }
    
    func remove(_ product: Product, coordinator: AppCoordinator) {
        coordinator.toggleFavorite(product)
    }
    
    func selectProduct(_ product: Product, coordinator: AppCoordinator) {
        coordinator.showProductDetail(product)
    }
}
