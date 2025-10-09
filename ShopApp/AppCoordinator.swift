//
//  AppCoordinator.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    
    // MARK: - Properties
    
    @Published var appState = AppState()
    @Published var settingsManager = SettingsManager()
    
    // MARK: - Methods

    func addToCart(_ product: Product, quantity: Int = 1) {
        appState.addToCart(product, quantity: quantity)
    }

    func toggleFavorite(_ product: Product) {
        appState.toggleFavorite(product)
    }
}

