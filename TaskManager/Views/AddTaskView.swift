//
//  AddTaskView.swift
//  TaskManager
//
//  Created by joylinm on 10/03/2025.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var accentColorManager: AccentColorManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    @State private var priority = "Low"
    @State private var pulseEffect: CGFloat = 1.0 // For pulse animation
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    let priorities = ["Low", "Medium", "High"]
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Form {
                TextField("Title", text: $title)
                    .foregroundColor(accentColorManager.accentColor)
                TextField("Description", text: $taskDescription)
                //                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                //                    .datePickerStyle(.automatic)
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    HStack {
                        Text("Select Date: \(formattedDate)")
                        Spacer() // Pushes text to the leading edge
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure it aligns to the start
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $showDatePicker) {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()  // Hides the default label
                        .padding()
                        .onChange(of: selectedDate) { _ in
                            showDatePicker = false  // Dismiss popover after selection
                        }
                }
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) { priority in
                        Text(priority).tag(priority)
                    }
                }
                // Use a VStack and align the button to center
                VStack {
                    Spacer() // Push content upwards
                    Button("Save") {
                        addTask()
                    }
                    .disabled(title.isEmpty) // Disable if title is empty
                    .frame(maxWidth: .infinity) // Make the button full-width
                    .padding() // Add padding around the button
                    .background(Color.blue) // Button background color
                    .foregroundColor(.white) // Button text color
                    .cornerRadius(10) // Rounded corners
                    .animation(
                        Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                        value: pulseEffect
                    )
                    .onChange(of: title) { _ in
                        // Only activate pulse effect when the button is not disabled
                        pulseEffect = title.isEmpty ? 1.0 : 1.1 // No pulse when disabled
                    }
                    Spacer() // Push content downwards
                }
                
            }
            
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Add Task")
        }
        
    }
    
    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.title = title
            newTask.taskDescription = taskDescription
            newTask.dueDate = dueDate
            newTask.priority = priority
            newTask.status = "Pending"
            newTask.isCompleted = false
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
    AddTaskView()
}
