//
//  MockData.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import Foundation

enum MockData {
    static let products: [Product] = {
        var productsList: [Product] = []
        for i in 1...20 {
            let product = Product(
                name: "Product \(i)",
                description: "Product description \(i). text.",
                price: Double(arc4random_uniform(9000) + 100) / 100.0,
                imageName: nil
            )
            productsList.append(product)
        }
        return productsList
    }()
}
