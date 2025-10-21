//
//  Logger.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 21.10.2025.
//

import Foundation

enum LogType: String {
    case info = "ℹ️ Info: "
    case warning = "⚠️ Warning: "
    case error = "❌ Error: "
}

final class Logger {
    
    // MARK: - Properties
    
    static let shared = Logger()
    
    // MARK: - Methods
    
    private func log(_ message: String,
                     logType: LogType) {
        
        print("\(logType.rawValue) \(message)")
    }
    
    func info(_ message: String) {
        log(message, logType: .info)
    }
    
    func warning(_ message: String) {
        log(message, logType: .warning)
    }
    
    func error(_ message: String) {
        log(message, logType: .error)
    }
}

let log = Logger.shared
