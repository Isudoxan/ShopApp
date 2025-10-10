//
//  FavoritesViewModel.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    @Published private(set) var favorites: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    private let appState: AppState

    // MARK: - Lifecycle
    
    init(appState: AppState) {
        self.appState = appState
        self.favorites = appState.favorites

        appState.$favorites
            .sink { [weak self] list in
                self?.favorites = list
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods

    func filtered() -> [Product] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanSearchText.isEmpty { return favorites }
        let textLowercades = cleanSearchText.lowercased()
        return favorites.filter { $0.name.lowercased().contains(textLowercades) || $0.description.lowercased().contains(textLowercades) }
    }

    func remove(_ product: Product) {
        appState.toggleFavorite(product)
    }
}
