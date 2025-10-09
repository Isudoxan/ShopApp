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
            Text("Loading..")
                .tabItem {
                    Label("Catalogue", systemImage: "list.bullet")
                }
        }
    }
}
