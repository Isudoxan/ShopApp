//
//  ProductListViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    @Published private(set) var products: [Product] = []

    private var cancellables = Set<AnyCancellable>()
    private var coordinator: AppCoordinator!
    
    var filteredProducts: [Product] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanSearchText.isEmpty { return products }
        let lowerCasedText = cleanSearchText.lowercased()
        return products.filter { $0.name.lowercased().contains(lowerCasedText) || $0.description.lowercased().contains(lowerCasedText) }
    }
    
    // MARK: - Methods
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.products = coordinator.products
        log.info("ProductListViewModel setup complete. Initial products: \(products.count).")
        
        coordinator.$products
            .sink { [weak self] newProducts in
                guard let self = self else { return }
                log.info("Received new product list update. Total: \(newProducts.count).")
                self.products = newProducts
            }
            .store(in: &cancellables)
    }
}
