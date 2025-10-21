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
    @Published var selectedProduct: Product?
    @Published var showProductDetail: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: AppCoordinator!
    
    
    var total: Double {
        items.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    // MARK: - Setup
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.items = coordinator.cartItems
        
        log.info("CartViewModel setup complete. Initial cart items: \(items.count).")
        
        coordinator.$cartItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items = newItems
                log.info("Cart updated. Total items: \(newItems.count).")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func increase(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity + 1)
        log.info("Increased quantity for \(item.product.name)")
    }
    
    func decrease(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity - 1)
        log.info("Decreased quantity for \(item.product.name)")
    }
    
    func remove(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: 0)
        log.info("Removed product \(item.product.name)")
    }
    
    func clearCart() {
        coordinator.clearCart()
        log.info("Cart cleared.")
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
        showProductDetail = true
        log.info("Selected product from cart: \(product.name)")
    }
}
