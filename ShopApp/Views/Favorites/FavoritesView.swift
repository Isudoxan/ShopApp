//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var ViewModel: FavoritesViewModel

    // MARK: - Lifecycle
    
    init() {
        _ViewModel = StateObject(wrappedValue: FavoritesViewModel(appState: AppState()))
    }

    // MARK: - Body
    
    var body: some View {
        let appState = coordinator.appState
        FavoritesContentView(viewModel: FavoritesViewModel(appState: appState))
    }
}
