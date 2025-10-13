//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = FavoritesViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            FavoritesContentView(viewModel: viewModel)
                .navigationDestination(
                    isPresented: Binding(
                        get: { coordinator.selectedProduct != nil },
                        set: { active in
                            if !active { coordinator.clearSelectedProduct() }
                        }
                    )
                ) {
                    if let selected = coordinator.selectedProduct {
                        ProductDetailView(product: selected, source: .favoritesPage, )
                    } else {
                        EmptyView()
                    }
                }
        }
        .onAppear {
            viewModel.setup(coordinator: coordinator)
        }
    }
}
