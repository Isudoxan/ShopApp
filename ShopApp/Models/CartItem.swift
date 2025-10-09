//
//  CartItem.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    var id: UUID { product.id }
    let product: Product
    var quantity: Int
}
