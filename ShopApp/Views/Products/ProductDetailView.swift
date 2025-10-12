//
//  ProductDetailView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct ProductDetailView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    let product: Product

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            if let imageName = product.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    )
            }
            Text(product.name)
                .font(.title2)
                .bold()
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Spacer()
            HStack(spacing: 12) {
                Button(action: {
                    coordinator.toggleFavorite(product)
                }) {
                    Label("Favorites", systemImage: coordinator.isFavorite(product) ? "heart.fill" : "heart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke())
                }
                Button(action: {
                    coordinator.addToCart(product)
                }) {
                    Label("To Cart", systemImage: "cart.badge.plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Detail")
    }
}
