//
//  SettingsManager.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 09.10.2025.
//

import Foundation
import SwiftUI
import Combine

enum AppTheme: String, Codable {
    case system
    case light
    case dark

    var colorSchemeOverride: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

final class SettingsManager: ObservableObject {
    @Published var selectedTheme: AppTheme = .system
}
