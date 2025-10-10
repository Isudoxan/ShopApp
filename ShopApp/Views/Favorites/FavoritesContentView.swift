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
                            VStack(alignment: .leading) {
                                Text(product.name).bold()
                                Text(String(format: "₴ %.2f", product.price)).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { coordinator.toggleFavorite(product) }) {
                                Image(systemName: "trash")
                            }
                        }
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
