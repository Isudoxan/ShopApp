//
//  ProductListViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Combine
import SwiftUI

final class ProductListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    @Published private(set) var products: [Product] = []
    
    @Published var selectedProduct: Product?
    @Published var showProductDetail: Bool = false
    @Published var showCartCheckmark: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: AppCoordinator!
    
    var filteredProducts: [Product] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanSearchText.isEmpty { return products }
        let lowerCasedText = cleanSearchText.lowercased()
        return products.filter {
            $0.name.lowercased().contains(lowerCasedText) ||
            $0.description.lowercased().contains(lowerCasedText)
        }
    }
    
    // MARK: - Setup
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.products = coordinator.products
        log.info("ProductListViewModel setup complete. Initial products: \(products.count)")
        
        coordinator.$products
            .sink { [weak self] newProducts in
                guard let self = self else { return }
                log.info("Received new product list update. Total: \(newProducts.count)")
                self.products = newProducts
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    func addToCart(_ product: Product) {
        coordinator.addToCart(product)
        log.info("Added product to cart: \(product.name)")
        
        showCartCheckmark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showCartCheckmark = false
        }
    }
    
    func toggleFavorite(_ product: Product) {
        coordinator.toggleFavorite(product)
        let isFav = coordinator.isFavorite(product)
        log.info("Toggled favorite for product: \(product.name). Now favorite: \(isFav)")
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
        showProductDetail = true
        log.info("Selected product for detail view: \(product.name)")
    }
    
    func isFavorite(_ product: Product) -> Bool {
        coordinator.isFavorite(product)
    }
}
