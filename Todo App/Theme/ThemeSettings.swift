//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Davide Aliti on 01/07/22.
//

import Foundation

final public class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    
    public static let shared = ThemeSettings()
}
