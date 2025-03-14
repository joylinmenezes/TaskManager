//
//  ThemeManager.swift
//  TaskManager
//
//  Created by joylinm on 11/03/2025.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedTheme: String = "light"
    
    // Possible theme options
    enum Theme: String {
        case system = "system"
        case light = "light"
        case dark = "dark"
    }
    
    // Current theme, using the system theme by default
    var currentTheme: Theme {
        Theme(rawValue: selectedTheme) ?? .system
    }
    
    func toggleMode() {
        switch currentTheme {
            case .system:
                selectedTheme = Theme.light.rawValue
            case .light:
                selectedTheme = Theme.dark.rawValue
            case .dark:
                selectedTheme = Theme.system.rawValue
        }
    }
    
}


