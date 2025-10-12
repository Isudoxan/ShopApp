//
//  ProductCardView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct ProductCardView: View {
    
    // MARK: - Properties
    
    let product: Product
    @Binding var isFavorite: Bool
    let onAddToCart: () -> Void
    let onToggleFavorite: () -> Void

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            imageView
            productInfoView
            Spacer()
            buttonsView
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.systemBackground))
            .shadow(radius: 1))
    }
    
    // MARK: - Views
    
    private var imageView: some View {
        Group {
            if let imageName = product.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var productInfoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(product.name)
                .font(.headline)
                .lineLimit(1)
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            Text(String(format: "%.2f ₴", product.price))
                .font(.subheadline)
                .bold()
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 8) {
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(.red)
            }
            Button(action: onAddToCart) {
                Image(systemName: "cart.badge.plus")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
