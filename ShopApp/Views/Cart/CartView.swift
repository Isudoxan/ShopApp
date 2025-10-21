//
//  CartView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct CartView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = CartViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            CartContentView(
                items: viewModel.items,
                total: viewModel.total,
                onIncrease: { viewModel.increase($0) },
                onDecrease: { viewModel.decrease($0) },
                onRemove: { viewModel.remove($0) },
                onSelect: { viewModel.selectProduct($0) },
                onClearCart: { viewModel.clearCart() }
            )
            .navigationTitle("Cart")
            .navigationDestination(isPresented: $viewModel.showProductDetail) {
                if let selected = viewModel.selectedProduct {
                    ProductDetailView(product: selected, source: .cartPage)
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                viewModel.setup(coordinator: coordinator)
            }
        }
    }
}
