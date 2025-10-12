//
//  AppState.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    
    // MARK: - Properties
    
    @Published var products: [Product] = MockData.products
    @Published var cartItems: [CartItem] = []
    @Published var favorites: [Product] = []

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    
    init() {
        cartItems = PersistenceService.shared.loadCartItems()
        favorites = PersistenceService.shared.loadFavorites()

        $cartItems
            .sink { PersistenceService.shared.saveCartItems($0) }
            .store(in: &cancellables)

        $favorites
            .sink { PersistenceService.shared.saveFavorites($0) }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods

    func addToCart(_ product: Product, quantity: Int = 1) {
        if let idx = cartItems.firstIndex(where: {
            $0.product.id == product.id
        }) {
            cartItems[idx].quantity += quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
    }

    func updateQuantity(for product: Product, quantity: Int) {
        guard let idx = cartItems.firstIndex(where: {
            $0.product.id == product.id
        }) else { return }
        if quantity <= 0 {
            cartItems.remove(at: idx)
        } else {
            cartItems[idx].quantity = quantity
        }
    }

    func clearCart() {
        cartItems.removeAll()
    }

    func toggleFavorite(_ product: Product) {
        if let idx = favorites.firstIndex(of: product) {
            favorites.remove(at: idx)
        } else {
            favorites.append(product)
        }
    }

    func isFavorite(_ product: Product) -> Bool {
        favorites.contains(product)
    }
}
