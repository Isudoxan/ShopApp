//
//  FavoritesContentView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct FavoritesContentView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: FavoritesViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    // MARK: - Body
    
    var body: some View {
        VStack {
            searchBar
            if viewModel.filtered().isEmpty {
                Spacer()
                Text("Empty now.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                scrollViewWithProducts
            }
        }
        .navigationTitle("Favorites")
    }
    
    // MARK: - Views
    
    private var searchBar: some View {
        SearchBar(text: $viewModel.searchText, placeholder: "Search in favorites")
            .padding(.horizontal)
    }
    
    private var scrollViewWithProducts: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filtered()) { product in
                    HStack {
                        if let imageName = product.imageName, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(Image(systemName: "cube.box.fill").foregroundColor(.gray))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .bold()
                            Text(String(format: "₴ %.2f", product.price))
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: { coordinator.toggleFavorite(product) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            .padding(.vertical)
        }
    }
}
