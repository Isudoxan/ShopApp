//
//  ProductListView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct ProductListView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = ProductListViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                if viewModel.filteredProducts.isEmpty {
                    Spacer()
                    Text("No results.")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    scrollViewWithCards
                }
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
                    ProductDetailView(product: selected, parent: 1)
                        .environmentObject(coordinator)
                } else {
                    EmptyView()
                }
            }
        }
        .overlay(
            Group {
                if coordinator.showCartCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: coordinator.showCartCheckmark)
                }
            }
        )
        .environmentObject(coordinator)
        .onAppear {
            viewModel.setup(coordinator: coordinator)
        }
    }
    
    // MARK: - Views
    
    private var searchBar: some View {
        SearchBar(text: $viewModel.searchText, placeholder: "Search in catalogue")
            .padding(.horizontal)
    }
    
    private var scrollViewWithCards: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCardView(
                        product: product,
                        isFavorite: Binding(
                            get: { coordinator.isFavorite(product) },
                            set: { _ in coordinator.toggleFavorite(product) }
                        ),
                        onAddToCart: { coordinator.addToCart(product) },
                        onToggleFavorite: { coordinator.toggleFavorite(product) }
                    )
                    .padding(.horizontal)
                    .onTapGesture {
                        coordinator.showProductDetail(product)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Catalogue")
    }
}
