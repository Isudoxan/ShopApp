//
//  Product.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    
    // MARK: - Properties
    
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String?
    
    // MARK: - Lifecycle

    init(id: UUID = UUID(), name: String, description: String, price: Double, imageName: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageName = imageName
    }
}
