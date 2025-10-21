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
                isPresented: $viewModel.showProductDetail
            ) {
                if let selected = viewModel.selectedProduct {
                    ProductDetailView(product: selected, source: .cataloguePage)
                } else {
                    EmptyView()
                }
            }
        }
        .overlay(checkMarkOverlay)
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
                        onAddToCart: { viewModel.addToCart(product) },
                        onToggleFavorite: { viewModel.toggleFavorite(product) },
                        product: product,
                        isFavorite: Binding(
                            get: { viewModel.isFavorite(product) },
                            set: { _ in viewModel.toggleFavorite(product) }
                        )
                    )
                    .onTapGesture {
                        viewModel.selectProduct(product)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Catalogue")
    }
    
    private var checkMarkOverlay: some View {
        Group {
            if viewModel.showCartCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: viewModel.showCartCheckmark)
            }
        }
    }
}
