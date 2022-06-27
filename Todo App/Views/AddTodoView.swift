//
//  AddTodoView.swift
//  Todo App
//
//  Created by Davide Aliti on 10/06/22.
//

import SwiftUI

struct AddTodoView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext

    @State private var name: String = ""
    @State private var priority: String = "Normal"
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    let priorities = ["High", "Normal", "Low"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    Button {
                        if self.name != "" {
                            let todo = Todo(context: viewContext)
                            todo.id = UUID()
                            todo.name = self.name
                            todo.priority = self.priority
                            do {
                                try viewContext.save()
                            } catch {
                                print("Error while saving: \(error)")
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid name"
                            self.errorMessage = "Make sure to enter something for the new todo item"
                            return
                        }
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }
                } //: VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }

                        }
                    }
            } //: VStack
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(self.errorTitle), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
            }
            
        } // NavigationView
    }
}

// MARK: - Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
