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
            if let imageName = product.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 72, height: 72)
                    .overlay(Image(systemName: "cube.box.fill").font(.system(size: 28)).foregroundColor(.gray))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name).font(.headline).lineLimit(1)
                Text(product.description).font(.subheadline).foregroundColor(.secondary).lineLimit(2)
                Text(String(format: "%.2f ₴", product.price)).font(.subheadline).bold()
            }
            Spacer()
            VStack(spacing: 8) {
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
                Button(action: onAddToCart) {
                    Image(systemName: "cart.badge.plus")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)).shadow(radius: 1))
    }
}
