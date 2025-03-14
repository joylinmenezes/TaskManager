//
//  EmptyTaskView.swift
//  TaskManager
//
//  Created by Teknip INC on 13/03/2025.
//

import SwiftUI

struct EmptyTaskView: View {
    @State private var tasks: [String] = [] // Empty initially
    @State private var isViewPresented = false // State variable to control navigation
        

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checklist")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue.opacity(0.6))
            
            Text("No tasks yet!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Stay organized and productive. Tap the '+' button at top to add your first task.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
        }
        .padding()
    }
}

#Preview {
    EmptyTaskView()
}
