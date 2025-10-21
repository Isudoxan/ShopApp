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
    
    
    @Published var settingsManager = SettingsManager()
    @Published var products: [Product] = MockData.products
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Product] = []
    @Published var selectedProduct: Product? = nil
    @Published var showCartCheckmark: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init() {
        log.info("Init AppCoordinator...")
        cartItems = PersistenceService.shared.loadCartItems()
        log.info("Fetch cart items...")
        favoriteItems = PersistenceService.shared.loadFavorites()
        log.info("Fetch favorites items...")
        
        /// Save on change
        $cartItems
            .sink { PersistenceService.shared.saveCartItems($0) }
            .store(in: &cancellables)
        
        $favoriteItems
            .sink { PersistenceService.shared.saveFavorites($0) }
            .store(in: &cancellables)
        log.info("AppCoordinator initialized successfully.")
    }
    
    // MARK: - Cart Methods
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        log.info("Adding item to cart...")
        if let idx = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[idx].quantity += quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
        log.info("Item added to cart.")
        triggerCartCheckmark()
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        log.info("Updating quantity...")
        guard let idx = cartItems.firstIndex(where: { $0.product.id == product.id }) else { return }
        if quantity <= 0 {
            cartItems.remove(at: idx)
        } else {
            cartItems[idx].quantity = quantity
        }
        log.info("Quantity updated.")
    }
    
    func clearCart() {
        log.info("Clearing cart...")
        cartItems.removeAll()
        log.info("Cart was cleaned.")
    }
    
    // MARK: - Favorites Methods
    
    func toggleFavorite(_ product: Product) {
        log.info("Toggle item to favorites")
        if let idx = favoriteItems.firstIndex(of: product) {
            favoriteItems.remove(at: idx)
        } else {
            favoriteItems.append(product)
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        return favoriteItems.contains(product)
    }
    
    // MARK: - Navigation
    
    func showProductDetail(_ product: Product) {
        log.info("Open product detail view for \(product)")
        selectedProduct = product
    }
    
    func clearSelectedProduct() {
        selectedProduct = nil
        log.info("Hide product detail view")
    }
    
    // MARK: - Cart Checkmark Animation
    
    func triggerCartCheckmark() {
        log.info("Show checkmark...")
        showCartCheckmark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                self.showCartCheckmark = false
            }
        }
    }
}
