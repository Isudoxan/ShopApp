//
//  PersistenceService.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation

final class PersistenceService {
    
    // MARK: - Properties
    
    static let shared = PersistenceService()
    private let defaults = UserDefaults.standard
    private let cartKey = "shopCart"
    private let favoritesKey = "shopFavorites"
    private let themeKey = "shopTheme"

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Methods
    
    /// Cart

    func saveCartItems(_ items: [CartItem]) {
        guard let data = try? encoder.encode(items) else { return }
        defaults.set(data, forKey: cartKey)
    }
    func loadCartItems() -> [CartItem] {
        guard let data = defaults.data(forKey: cartKey),
                let items = try? decoder.decode([CartItem].self, from: data) else { return [] }
        return items
    }

    /// Favorites

    func saveFavorites(_ products: [Product]) {
        guard let data = try? encoder.encode(products) else { return }
        defaults.set(data, forKey: favoritesKey)
    }
    func loadFavorites() -> [Product] {
        guard let data = defaults.data(forKey: favoritesKey),
                let items = try? decoder.decode([Product].self, from: data) else { return [] }
        return items
    }

    /// Theme
    
    func saveTheme(_ theme: AppTheme) {
        defaults.set(theme.rawValue, forKey: themeKey)
    }
    func loadTheme() -> AppTheme {
        guard let raw = defaults.string(forKey: themeKey),
              let theme = AppTheme(rawValue: raw) else { return .system }
        return theme
    }
}
