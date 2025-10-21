//
//  CartViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import Combine

final class CartViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var items: [CartItem] = []
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: AppCoordinator!
    
    var total: Double {
        items.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    // MARK: - Lifecycle
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.items = coordinator.cartItems
        log.info("CartViewModel setup complete. Initial cart items: \(items.count).")
        
        coordinator.$cartItems
            .sink { [weak self] newItems in
                guard let self = self else { return }
                self.items = newItems
                log.info("Cart updated. Total items: \(newItems.count).")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func increase(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity + 1)
        log.info("Increased quantity for product '\(item.product.name)' to \(item.quantity + 1).")
    }
    
    func decrease(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity - 1)
        log.info("Decreased quantity for product '\(item.product.name)' to \(item.quantity - 1).")
    }
    
    func remove(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: 0)
        log.info("Removed product from cart: \(item.product.name).")
    }
    
    func clearCart() {
        coordinator.clearCart()
        log.info("Cleared the cart.")
    }
    
    func selectProduct(_ product: Product) {
        coordinator.showProductDetail(product)
        log.info("Selected product from cart: \(product.name).")
    }
}
