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
    private var cancelLables = Set<AnyCancellable>()
    private let appState: AppState
    
    var total: Double {
        items.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    // MARK: - Lifecycle
    
    init(appState: AppState) {
        self.appState = appState
        self.items = appState.cartItems

        appState.$cartItems
            .sink { [weak self] list in
                self?.items = list
            }
            .store(in: &cancelLables)
    }
    
    // MARK: - Methods

    func increase(_ item: CartItem) {
        appState.updateQuantity(for: item.product, quantity: item.quantity + 1)
    }

    func decrease(_ item: CartItem) {
        appState.updateQuantity(for: item.product, quantity: item.quantity - 1)
    }

    func clearCart() {
        appState.clearCart()
    }
}
