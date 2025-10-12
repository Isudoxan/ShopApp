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
    @StateObject private var viewModel: ProductListViewModel
    
    // MARK: - Lifecycle

    init() {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(products: MockData.products))
    }

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
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .navigationTitle("Catalogue")
        }
    }
    
    // MARK: - Views
    
    private var searchBar: some View {
        SearchBar(text: $viewModel.searchText,
                  placeholder: "Search in catalogue")
            .padding(.horizontal)
    }
    
    private var scrollViewWithCards: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(value: product) {
                        ProductCardView(
                            product: product,
                            isFavorite: Binding(
                                get: {
                                    coordinator.isFavorite(product)
                                },
                                set: { _ in
                                    coordinator.toggleFavorite(product)
                                }
                            ),
                            onAddToCart: { coordinator.addToCart(product) },
                            onToggleFavorite: { coordinator.toggleFavorite(product) }
                        )
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical)
        }
    }
}
