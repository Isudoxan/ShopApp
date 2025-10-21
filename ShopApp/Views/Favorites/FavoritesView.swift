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
            FavoritesContentView(
                searchText: $viewModel.searchText,
                favorites: viewModel.filteredFavorites,
                total: viewModel.total,
                onRemove: { viewModel.remove($0) },
                onSelect: { viewModel.selectProduct($0) }
            )
            .navigationTitle("Favorites")
            .navigationDestination(isPresented: $viewModel.showProductDetail) {
                if let selected = viewModel.selectedProduct {
                    ProductDetailView(product: selected, source: .favoritesPage)
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
