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
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.items.isEmpty {
                emptyState
            } else {
                listWithProducts
                resultView
                emptyCartButton
            }
        }
        .navigationTitle("Cart")
    }
    
    // MARK: - Views
    
    private var listWithProducts: some View {
        List {
            ForEach(viewModel.items) { item in
                productRow(item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectProduct(item.product)
                    }
                    .padding(.vertical, 6)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func productRow(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            productImage(item.product)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .bold()
                Text(String(format: "₴ %.2f", item.product.price))
                    .foregroundColor(.secondary)
                    .font(.subheadline)
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
            
            Button(action: { viewModel.remove(item) }) {
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
    
    private var emptyState: some View {
        VStack {
            Spacer()
            Text("Cart is empty")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var resultView: some View {
        HStack {
            Text("Result:")
                .font(.headline)
            Spacer()
            Text(String(format: "₴ %.2f", viewModel.total))
                .font(.headline)
        }
        .padding()
    }
    
    private var emptyCartButton: some View {
        Button(role: .destructive, action: { viewModel.clearCart() }) {
            Text("Empty cart")
                .frame(maxWidth: .infinity)
                .padding()
        }
        .padding(.horizontal)
    }
}
