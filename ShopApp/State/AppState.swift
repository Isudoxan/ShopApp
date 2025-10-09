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

    // MARK: - Methods
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        if let itemExistInCart = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[itemExistInCart].quantity += quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
    }

    func updateQuantity(for product: Product, quantity: Int) {
        guard let itemExistInCart = cartItems.firstIndex(where: { $0.product.id == product.id }) else { return }
        if quantity <= 0 {
            cartItems.remove(at: itemExistInCart)
        } else {
            cartItems[itemExistInCart].quantity = quantity
        }
    }

    func clearCart() {
        cartItems.removeAll()
    }

    func toggleFavorite(_ product: Product) {
        if let itemExistInFavorites = favorites.firstIndex(of: product) {
            favorites.remove(at: itemExistInFavorites)
        } else {
            favorites.append(product)
        }
    }

    func isFavorite(_ product: Product) -> Bool {
        favorites.contains(product)
    }
}
