//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import SwiftUI

@main
struct ShopApp: App {
    @StateObject var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .preferredColorScheme(coordinator.settingsManager.selectedTheme.colorSchemeOverride)
        }
    }
}
