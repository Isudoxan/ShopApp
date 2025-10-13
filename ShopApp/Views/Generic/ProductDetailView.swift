//
//  ProductDetailView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct ProductDetailView: View {
    
    // MARK: - Init Source Enum
    
    enum InitSource {
        case cataloguePage
        case favoritesPage
        case cartPage
    }
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    let product: Product
    let source: InitSource

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            image
            productName
            productDescription
            Spacer()
            buttonsView
        }
        .overlay(
            checkMarkOverlay
        )
        .padding()
        .navigationTitle("Detail")
    }
    
    // MARK: - Views
    
    private var image: some View {
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
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var productName: some View {
        Text(product.name)
            .font(.title2)
            .bold()
    }
    
    private var productDescription: some View {
        Text(product.description)
            .font(.body)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
    
    private var buttonsView: some View {
        HStack(spacing: 12) {
            Button(action: {
                coordinator.toggleFavorite(product)
            }) {
                Label("Favorites", systemImage: coordinator.isFavorite(product) ? "heart.fill" : "heart")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())
            }
            
            Button(action: {
                coordinator.addToCart(product)
                coordinator.triggerCartCheckmark()
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
    
    private var checkMarkOverlay: some View {
        Group {
            if source != .cataloguePage {
                if coordinator.showCartCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: coordinator.showCartCheckmark)
                        .zIndex(100)
                }
            }
        }
    }
}
