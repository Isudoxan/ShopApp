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
            SearchBar(text: $viewModel.searchText, placeholder: "Search in favorites")
                .padding(.horizontal)
            
            if viewModel.filtered().isEmpty {
                Spacer()
                Text("Empty now.").foregroundColor(.secondary)
                Spacer()
            } else {
                List {
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
                                Text(product.name).bold()
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
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        let items = viewModel.filtered()
                        for indexToRemove in indexSet {
                            let itemToRemove = items[indexToRemove]
                            viewModel.remove(itemToRemove)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Favorites")
    }
}
