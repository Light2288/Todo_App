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
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
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
                                Circle()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                                Text(todo.name ?? "Unknown")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(todo.priority ?? "Unknown")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.systemGray2))
                                    .padding(3)
                                    .frame(minWidth: 62)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                    )
                            }
                            .padding(.vertical, 10)
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
                        .accentColor(themes[self.theme.themeSettings].themeColor)

                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .accentColor(themes[self.theme.themeSettings].themeColor)
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
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
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
                    .accentColor(themes[self.theme.themeSettings].themeColor)
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
        .navigationViewStyle(StackNavigationViewStyle())
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
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
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
