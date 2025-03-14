//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Teknip INC on 10/03/2025.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accentColorManager: AccentColorManager
    @ObservedObject var themeManager = ThemeManager()
    @ObservedObject var task: Task
    @State private var isPriorityBtnDisabled = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading,spacing: 20){
                Text(task.title ?? "Untitled")
                    .font(.title)
                    .foregroundColor(.blue)
                    .bold()
                Text(task.taskDescription ?? "No description available")
                    .font(.body)
                    .foregroundColor(.gray)
                Text("Due Date: \(task.dueDate?.formatted() ?? "No Date")")
                    .font(.subheadline)
                Text("Priority: \(task.priority ?? "Low")")
                    .font(.subheadline)
                HStack {
                    Button(action: {
                        //                    task.status = "Completed"
                        //                    task.isCompleted.toggle()
                        //                    PersistenceController.shared.saveContext()
                        //                    dismiss()  //
                        markAsCompletedTask()
                    }) {
                        Text(task.isCompleted ? "Marked as Completed" : "Mark as Completed")
                            .padding()
                            .background(task.isCompleted == true ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(task.isCompleted)
                    Spacer()
                    Button(role: .destructive) {
                        showAlert = true
                    } label: {
                        Text("Delete")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding([.horizontal, .vertical])
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(1.0))  // Background Color
            .cornerRadius(10)  // Rounded Corners
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)  // Shadow
            .padding(.horizontal, 16) // Add horizontal spacing from edges
            //        .padding(.vertical, 8)    // Add vertical spacing between rows
            .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
            .alert("Are you sure you want to delete this?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    print("Item Deleted!") // Handle delete action
                    //                viewContext.delete(task)
                    //                PersistenceController.shared.saveContext()
                    //                dismiss()
                    deleteTask()
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .navigationTitle("Task Details")
            Spacer()
        }
    }
    
    // Function to handle deletion
    private func deleteTask() {
        withAnimation {
            viewContext.delete(task)
            do {
                try viewContext.save()
                dismiss() // Close the screen after deletion
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
    
    private func markAsCompletedTask() {
        withAnimation {
            task.status = "Completed"
            task.isCompleted.toggle()
//            PersistenceController.shared.saveContext()
            dismiss()  //
            do {
                try viewContext.save()
                dismiss() // Close the screen after deletion
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
//    TaskDetailView()
}
