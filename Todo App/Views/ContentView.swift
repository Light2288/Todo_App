//
//  ContentView.swift
//  Todo App
//
//  Created by Davide Aliti on 10/06/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    @State private var showingAddTodoView: Bool = false
    @State private var showingSettingsView: Bool = false
    @State private var animatingButton: Bool = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)],
        animation: .default)
    
    private var todos: FetchedResults<Todo>
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos) { todo in
                        NavigationLink {
                            Text("Item \(todo.name!)")
                        } label: {
                            HStack {
                                Text(todo.name ?? "Unknown")
                                Spacer()
                                Text(todo.priority ?? "Unknown")
                            }
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                        self.showingSettingsView.toggle()
                        } label: {
                            Label("Add Item", systemImage: "paintbrush")
                        }
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView().environmentObject(self.iconSettings)
                        }

                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                if todos.count == 0 {
                    EmptyListView()
                }
            } //: ZStack
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, self.viewContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: self.animatingButton)
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }) //: Button
                    .onAppear {
                        DispatchQueue.main.async {
                            self.animatingButton.toggle()
                        }
                    }
                } //: ZStack
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
    }
    
    private func addItem() {
        self.showingAddTodoView.toggle()
    }
    
    private func deleteTodo(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
