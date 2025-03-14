//
//  TaskRowView.swift
//  TaskManager
//
//  Created by joylinm on 10/03/2025.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: Task
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(task.title ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : accentColorManager.accentColor)
                Text(task.dueDate?.formatted() ?? "No Date")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
            Text(task.priority ?? "Low")
                .font(.caption)
                .padding(5)
//                .background(priorityColor(task.priority ?? "Low"))
                .cornerRadius(5)
                .foregroundColor(task.priority == "High" ? .red : task.priority == "Medium" ? .yellow : .green)
        }
        .padding()
        .background(task.isCompleted ? Color.gray.opacity(0.1) : Color.blue.opacity(0.1) )
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private func priorityColor(_ priority: String) -> Color {
        switch priority {
            case "High": return .red
            case "Medium": return .orange
            case "Low": return .green
            default: return .gray
        }
    }
}

#Preview {
//    TaskRowView(task: )
}
