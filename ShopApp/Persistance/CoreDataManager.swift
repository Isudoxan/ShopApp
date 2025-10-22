//
//  CoreDataManager.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 22.10.2025.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "ShopApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                log.info("💾 Core Data context saved successfully.")
            } catch {
                log.error("⚠️ Failed to save Core Data context: \(error.localizedDescription)")
            }
        }
    }
}
