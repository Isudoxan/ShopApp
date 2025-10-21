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
        searchBar
        VStack {
            if viewModel.filteredFavorites().isEmpty {
                emptyState
            } else {
                listView
                totalView
            }
        }
        .navigationTitle("Favorites")
    }
    
    // MARK: - Views
    
    private var searchBar: some View {
        SearchBar(text: $viewModel.searchText, placeholder: "Search in favorites")
            .padding(.horizontal)
    }
    
    private var emptyState: some View {
        VStack {
            Spacer()
            Text("Empty now")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.filteredFavorites()) { product in
                productRow(product)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectProduct(product, coordinator: coordinator)
                    }
                    .padding(.vertical, 6)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func productRow(_ product: Product) -> some View {
        HStack(spacing: 12) {
            productImage(product)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .bold()
                Text(product.description)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            Spacer()
            
            Button(action: { viewModel.remove(product, coordinator: coordinator) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    private func productImage(_ product: Product) -> some View {
        Group {
            if let imageName = product.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "cube.box.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var totalView: some View {
        HStack {
            Text("Total Price:")
                .font(.headline)
            Spacer()
            Text(String(format: "₴ %.2f", viewModel.total))
                .font(.headline)
        }
        .padding()
    }
}
