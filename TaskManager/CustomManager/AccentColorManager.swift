//
//  AccentColorManager.swift
//  TaskManager
//
//  Created by Teknip INC on 12/03/2025.
//

import Foundation

import SwiftUI

class AccentColorManager: ObservableObject {
    @AppStorage("accentColor") private var storedColor: String = "Blue" // Default color
    @Published var accentColor: Color = .black
    
    static let shared = AccentColorManager()
    
    private init() {
        updateColor()
    }
    
    func updateColor() {
//        accentColor = color(for: storedColor)
        
      //  Also can be used this way
        accentColor = AccentColorManager.colorFromName(storedColor)
    }
    
    func setAccentColor(_ colorName: String) {
        storedColor = colorName
        updateColor()
    }
    
    static func colorFromName(_ name: String) -> Color {
        switch name {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .blue
        }
    }
}
