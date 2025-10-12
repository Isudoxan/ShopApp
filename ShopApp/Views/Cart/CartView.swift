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
            ZStack {
                CartContentView(viewModel: viewModel)
            }
            .navigationDestination(
                isPresented: Binding(
                    get: { coordinator.selectedProduct != nil },
                    set: { active in
                        if !active { coordinator.clearSelectedProduct() }
                    }
                )
            ) {
                if let selected = coordinator.selectedProduct {
                    ProductDetailView(product: selected)
                        .environmentObject(coordinator)
                } else {
                    EmptyView()
                }
            }
        }
        .environmentObject(coordinator)
        .onAppear {
            viewModel.setup(coordinator: coordinator)
        }
    }
}
