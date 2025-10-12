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
    
    @Published var cartItems: [CartItem] = [] // <- для ViewModel
    @Published var selectedProduct: Product? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init() {
        appState.$cartItems
            .sink { [weak self] items in
                self?.cartItems = items
            }
            .store(in: &cancellables)
        
        appState.$favorites
            .sink { [weak self] favs in
                self?.favorites = favs
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        appState.addToCart(product, quantity: quantity)
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        appState.updateQuantity(for: product, quantity: quantity)
    }
    
    func clearCart() {
        appState.clearCart()
    }
    
    func toggleFavorite(_ product: Product) {
        appState.toggleFavorite(product)
    }
    
    func isFavorite(_ product: Product) -> Bool {
        appState.isFavorite(product)
    }
    
    // MARK: - Navigation
    
    func showProductDetail(_ product: Product) {
        selectedProduct = product
    }
    
    func clearSelectedProduct() {
        selectedProduct = nil
    }
}
