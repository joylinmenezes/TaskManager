//
//  SettingsView.swift
//  TaskManager
//
//  Created by Teknip INC on 11/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager // Access shared AccentColorManager
    @EnvironmentObject var modeManager: ModeManager  // Access shared ModeManager
    @ObservedObject var themeManager = ThemeManager() // Access property from ThemeManager
    let colors: [(name: String, color: Color)] = [
        ("blue", .blue), ("red", .red), ("green", .green),
        ("orange", .orange), ("purple", .purple)
    ]
    let modes = ["dark", "light"]
    @State private var isDarkMode = false // State to track toggle status
    
    var body: some View {
        Form {
            Section(header: Text("Select Accent Color")) {
                ForEach(colors, id: \.name) { color in
                    Button(action: {
                        accentColorManager.setAccentColor(color.name)
                    }) {
                        HStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 24, height: 24)
                            Text(color.name.capitalized)
                                .foregroundColor(.primary)
                            Spacer()
                            if accentColorManager.accentColor == color.color {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(color.color)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Select Mode Type")) {
                VStack (alignment: .leading, spacing: 10){
                    Text("Current Mode: \(modeManager.colorScheme == .dark ? "Dark Mode" : "Light Mode")")
                    Button(action: {
                        modeManager.toggleMode()  // Dynamically update AppStorage value
                    }) {
                        Text("Switch Mode")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensures no unwanted tap interactions outside
                }
                .padding(.vertical, 5)
            }
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
        .navigationTitle("Settings")
    }
}
    


#Preview {
    SettingsView()
}
