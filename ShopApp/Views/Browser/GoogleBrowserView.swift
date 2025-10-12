//
//  GoogleBrowserView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//


import SwiftUI

struct GoogleBrowserView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    let url: URL = URL(string: "https://www.google.com")!

    // MARK: - Methods
    
    func makeUIViewController(context: Context) -> WebViewController {
        let viewController = WebViewController()
        viewController.url = url
        return viewController
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {}
}
