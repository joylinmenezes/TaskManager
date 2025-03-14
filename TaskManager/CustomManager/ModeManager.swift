//
//  ModeManager.swift
//  TaskManager
//
//  Created by joylinm on 12/03/2025.
//

import Foundation
import SwiftUI

class ModeManager: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false  // Persist user preference
    @Published var colorScheme: ColorScheme? = nil  // Track current mode
    static let shared = ModeManager()  // Singleton instance
    
    private init() {
        colorScheme = isDarkMode ? .dark : .light
    }
//    
    func toggleMode() {
        isDarkMode.toggle()
        colorScheme = isDarkMode ? .dark : .light
       
    }
}
