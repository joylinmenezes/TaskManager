//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Teknip INC on 10/03/2025.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var modeManager = ModeManager.shared  // Shared instance
    @StateObject private var accentColorManager = AccentColorManager.shared
    @AppStorage("accentColor") private var selectedAccentColor: String = "Blue"
        

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)// Pass the managed object context
                .environmentObject(themeManager) // Pass the ThemeManager to the environment
                .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light) // Apply the theme
                .environmentObject(modeManager)  // Inject globally
                .preferredColorScheme(modeManager.colorScheme)  // Apply dynamically
                .environmentObject(accentColorManager) // Inject theme manager globally
//                .accentColor(color(for : selectedAccentColor))// Apply the selected accent color
        }
    }
}
