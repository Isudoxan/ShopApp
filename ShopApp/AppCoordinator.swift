//
//  AppCoordinator.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    
    // MARK: - Properties
    
    @Published var appState = AppState()
    @Published var settingsManager = SettingsManager()
    @Published var favorites: [Product] = []
    @Published var cart: [Product] = []
    
    @Published var selectedProduct: Product? = nil
    
    // MARK: - Methods
    
    func isFavorite(_ product: Product) -> Bool {
        appState.isFavorite(product)
    }
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        appState.addToCart(product, quantity: quantity)
    }

    func toggleFavorite(_ product: Product) {
        appState.toggleFavorite(product)
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        appState.updateQuantity(for: product, quantity: quantity)
    }
    
    // MARK: - Navigation
    
    func showProductDetail(_ product: Product) {
        selectedProduct = product
    }
    
    func clearSelectedProduct() {
        selectedProduct = nil
    }
}
