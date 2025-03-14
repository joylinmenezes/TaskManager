//
//  TaskListView.swift
//  TaskManager
//
//  Created by Teknip INC on 11/03/2025.
//

import SwiftUI
import Shimmer

//enum TaskStatus: String, CaseIterable {
//    case all, completed, pending
//}

//enum SortOption: String, CaseIterable {
//    case priority, dueDate, title
//}





struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dueDate, order: .forward)],   animation: .default)
    private var tasks: FetchedResults<Task>
    @ObservedObject var themeManager = ThemeManager()
    @EnvironmentObject var modeManager: ModeManager  // Access shared ModeManager
    @State private var isLoading = true
    @State private var filterStatus: TaskStatus = .all
    @State private var sortOption: SortOption = .priority
    @State private var isDetailPresented = false
    @State private var selectedItem: Task?
    @State private var recentlyDeletedTask: Task?
    @State private var showUndoSnackbar = false
    @State private var undoAction: (() -> Void)?
    
    
    enum TaskStatus: String, CaseIterable , Identifiable {
        case all = "All"
        case completed = "Completed"
        case pending = "Pending"
        
        var id: String { self.rawValue }
    }
    
    enum SortOption: String, CaseIterable {
        case priority, dueDate, title
    }
    
    // Separate filtering logic
    private var filteredByStatus: [Task] {
        switch filterStatus {
            case .all:
                return Array(tasks)
            case .completed:
                return tasks.filter { $0.isCompleted }
            case .pending:
                return tasks.filter { !$0.isCompleted }
        }
    }
    
    // Separate sorting logic
    private var sortedTasks: [Task] {
        switch sortOption {
            case .priority:
                return filteredByStatus.sorted { ($0.priority ?? "Low") < ($1.priority ?? "Low") }
            case .dueDate:
                return filteredByStatus.sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
            case .title:
                return filteredByStatus.sorted { ($0.title ?? "") < ($1.title ?? "") }
        }
    }
    
    private func moveTask(from source: IndexSet, to destination: Int) {
        // Implement task reordering logic
       
    }
    
    private func deleteTask(at offsets: IndexSet) {
        // Implement task deletion logic
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }

    init() {
        _tasks = FetchRequest(
            entity: Task.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter and Sort Controls
                HStack(alignment: .center) {
                    Picker("Sort By", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: .infinity)// This picker takes up remaining space
                    .layoutPriority(2)// Higher priority for this picker
                    .accessibilityLabel("filter for sort type")
                    Spacer()
                    Picker("Filter", selection: $filterStatus) {
                        ForEach(TaskStatus.allCases) { status in
                            Text(status.rawValue)
                                .tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(width: 130)  // Fixed width for this picker
                    .layoutPriority(1)  // Lower priority for this picker
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity) // Ensures HStack doesn't shrink
                .accessibilityLabel("filter for priority type")
                
                //to make button appear after scroll list
                VStack {
                    // List of Tasks
                    ScrollView { //Required for LazyVStack
                        //                    List(sortedTasks) { task in
                        //                        NavigationLink(destination: TaskDetailView(task: task)) {
                        //                            TaskRowView(task: task)
                        //                        }
                        //                    }
                        
                        if sortedTasks.isEmpty {
                            EmptyTaskView()
                        } else {
                            if isLoading {
                                // Placeholder with shimmer effect
                                VStack(alignment: .leading, spacing: 20) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        TaskRowPlaceholderView()
                                            .shimmering(active: true) // Uses Shimmer package
                                    }
                                }
                            } else {
                                // Actual content when loaded
                                LazyVStack(alignment: .leading, spacing: 20) {
                                    ForEach(sortedTasks, id: \.self) { task in
                                        Button(action: {
                                            // Set the selected item and trigger the navigation
                                            selectedItem = task
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                                isDetailPresented.toggle()
                                            }
                                        }) {
                                            TaskRowView(task: task)
                                                .opacity(isLoading ? 0 : 1)
                                                .scaleEffect(isLoading ? 0.9 : 1)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isLoading)
                                                .swipeActions(edge: .trailing) {
                                                    Button(role: .destructive) {
                                                        deleteTask(task)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                                .swipeActions(edge: .leading) {
                                                    Button {
                                                        completeTask(task)
                                                    } label: {
                                                        Label("Complete", systemImage: "checkmark.circle.fill")
                                                    }
                                                    .tint(.green)
                                                }
                                        }
                                    }.onMove(perform: moveTask)
                                    
                                }
                                .padding()
                                
                                // Snackbar (Undo Action)
                                if showUndoSnackbar {
                                    HStack {
                                        Text("Task Deleted")
                                        Spacer()
                                        Button("Undo") {
                                            undoAction?()
                                            showUndoSnackbar = false
                                        }
                                        .foregroundColor(.blue)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.9))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .onAppear {
                // Simulate loading delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)// adjust text color for contrast
            .toolbarRole(.editor)
                
                .safeAreaInset(edge: .bottom) { // to make it fix at bottom above safe area
                    NavigationLink(destination: SettingsView()) {
                        Text("Go to Settings")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .background(Color.clear.shadow(radius: 5)) // Adds a floating effect
                }
            // Navigation link to Task Detail View
                .background(
                    NavigationLink(
                        destination: TaskDetailView(task: selectedItem ?? Task()),
                        isActive: $isDetailPresented
                    ) {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle()) // Fix: Removes unwanted tap area
                )
            // Navigation link to Settings View
            //            NavigationLink(destination: SettingsView()) {
            //                Text("Go to Settings")
            //                    .padding()
            //                    .foregroundColor(.blue)
            //                    .background(Color.white)
            //                    .cornerRadius(10)
            //            }
            //            .padding()
            
                .background(themeManager.currentTheme == .dark ? Color.black : Color.white)
//                .background(modeManager.colorScheme == .dark ? Color.black : Color.white)
//                .background(colorScheme == .dark ? Color.black : Color.white)
        }
        //            .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }
    
    
    // 🗑️ Delete Task from Core Data (with Undo)
    private func deleteTask(_ task: Task) {
        recentlyDeletedTask = task
        viewContext.delete(task)
        
        do {
            try viewContext.save()
            
            undoAction = {
                if let deletedTask = recentlyDeletedTask {
                    let restoredTask = Task(context: viewContext)
                    restoredTask.id = deletedTask.id
                    restoredTask.title = deletedTask.title
                    restoredTask.isCompleted = deletedTask.isCompleted
                    try? viewContext.save()
                }
            }
            
            withAnimation {
                showUndoSnackbar = true
            }
            
            // Auto-hide snackbar after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showUndoSnackbar = false
                }
            }
            
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    // ✅ Mark Task as Completed in Core Data
    private func completeTask(_ task: Task) {
        task.isCompleted.toggle()
        try? viewContext.save()
    }
        
}



#Preview {
    TaskListView()
}
