//
//  CartView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct CartView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: CartViewModel
    
    // MARK: - Lifecycle

    init() {
        _viewModel = StateObject(wrappedValue: CartViewModel(appState: AppState()))
    }

    // MARK: - Body
    
    var body: some View {
        let appState = coordinator.appState
        CartContentView(viewModel: CartViewModel(appState: appState))
    }
}
