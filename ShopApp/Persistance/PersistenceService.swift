//
//  PersistenceService.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import CoreData

final class PersistenceService {
    
    // MARK: - Properties
    
    static let shared = PersistenceService()
    private let context = CoreDataManager.shared.context

    // MARK: - Cart

    func saveCartItems(_ items: [CartItem]) {
        clearEntity(named: "CartItemEntity")

        for item in items {
            let entity = CartItemEntity(context: context)
            entity.id = UUID()
            entity.productId = item.product.id
            entity.name = item.product.name
            entity.price = item.product.price
            entity.quantity = Int64(item.quantity)
            entity.imageName = item.product.imageName
        }

        CoreDataManager.shared.saveContext()
        log.info("🛒 Saved \(items.count) cart items.")
    }

    func loadCartItems() -> [CartItem] {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map {
                CartItem(product: Product(
                    id: $0.productId ?? UUID(),
                    name: $0.name ?? "",
                    description: "",
                    price: $0.price,
                    imageName: $0.imageName
                ), quantity: Int($0.quantity))
            }
        } catch {
            log.error("⚠️ Failed to load cart items: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Favorites

    func saveFavorites(_ products: [Product]) {
        clearEntity(named: "FavoriteEntity")

        for product in products {
            let entity = FavoriteEntity(context: context)
            entity.id = UUID()
            entity.productId = product.id
            entity.name = product.name
            entity.price = product.price
            entity.descriptionText = product.description
            entity.imageName = product.imageName
        }

        CoreDataManager.shared.saveContext()
        log.info("❤️ Saved \(products.count) favorites.")
    }

    func loadFavorites() -> [Product] {
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map {
                Product(id: $0.productId ?? UUID(),
                        name: $0.name ?? "",
                        description: $0.descriptionText ?? "",
                        price: $0.price,
                        imageName: $0.imageName)
            }
        } catch {
            log.error("⚠️ Failed to load favorites: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Theme

    func saveTheme(_ theme: AppTheme) {
        clearEntity(named: "ThemeEntity")
        let entity = ThemeEntity(context: context)
        entity.id = UUID()
        entity.theme = theme.rawValue
        CoreDataManager.shared.saveContext()
        log.info("🎨 Saved theme: \(theme.rawValue)")
    }

    func loadTheme() -> AppTheme {
        let request: NSFetchRequest<ThemeEntity> = ThemeEntity.fetchRequest()
        guard let result = try? context.fetch(request).first,
              let raw = result.theme,
              let theme = AppTheme(rawValue: raw)
        else {
            return .system
        }
        log.info("🎨 Loaded theme: \(theme.rawValue)")
        return theme
    }

    private func clearEntity(named name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            log.error("⚠️ Failed to clear entity \(name): \(error.localizedDescription)")
        }
    }
}
