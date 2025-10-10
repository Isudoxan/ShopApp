//
//  MainTabView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ProductListView()
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
            CartView()
                .tabItem { Label("Cart", systemImage: "cart.fill") }
        }
    }
}
