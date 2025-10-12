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
    
    init() {}
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.items = coordinator.cartItems
        
        coordinator.$cartItems
            .sink { [weak self] newItems in
                self?.items = newItems
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func increase(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity + 1)
    }
    
    func decrease(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: item.quantity - 1)
    }
    
    func remove(_ item: CartItem) {
        coordinator.updateQuantity(for: item.product, quantity: 0)
    }
    
    func clearCart() {
        coordinator.clearCart()
    }
    
    func selectProduct(_ product: Product) {
        coordinator.showProductDetail(product)
    }
}
