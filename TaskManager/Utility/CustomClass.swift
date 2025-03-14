//
//  CustomClass.swift
//  TaskManager
//
//  Created by Teknip INC on 11/03/2025.
//

import SwiftUI

func color(for colorName: String) -> Color {
    switch colorName {
    case "Blue":
        return Color("ColorAccentBlue") // Custom color from asset
    case "Red":
            return Color("ColorAccentRed") // Custom color from asset
    case "Green":
            return Color("ColorAccentGreen") // Custom color from asset
    case "Orrange":
            return Color("ColorAccentOrrange") // Custom color from asset
    case "Purple":
            return Color("ColorAccentPurple") // Custom color from asset
    default:
        return Color("AccentBlue")
    }
}
