//
//  CartContentView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct CartContentView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CartViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.items.isEmpty {
                Spacer()
                Text("Cart is empty")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.product.name).bold()
                                Text(String(format: "₴ %.2f", item.product.price))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Button(action: { viewModel.decrease(item) }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title2)
                                }
                                Text("\(item.quantity)")
                                    .frame(minWidth: 32)
                                Button(action: { viewModel.increase(item) }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete { indexSet in
                        for indexForDelete in indexSet {
                            let itemToDelete = viewModel.items[indexForDelete]
                            coordinator.updateQuantity(for: itemToDelete.product, quantity: 0)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                HStack {
                    Text("Result:").font(.headline)
                    Spacer()
                    Text(String(format: "₴ %.2f", viewModel.total)).font(.headline)
                }
                .padding()

                Button(role: .destructive, action: { viewModel.clearCart() }) {
                    Text("Empty cart")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Cart")
    }
}
