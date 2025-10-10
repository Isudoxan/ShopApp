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
                .tabItem { Label("Каталог", systemImage: "list.bullet") }
        }
    }
}
