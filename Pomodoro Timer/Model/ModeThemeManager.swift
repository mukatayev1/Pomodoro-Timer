//
//  ModeThemeManager.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/16.
//

import Foundation

struct ModeThemeManager {
    static let isDarkModeKey = "isDarkMode"
    
    static var currentTheme: ModeTheme {
        return isDarkMode() ? .dark : .light
    }
    
    static func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: isDarkModeKey)
    }
    
    static func enableDarkMode() {
        UserDefaults.standard.set(true, forKey: isDarkModeKey)
        NotificationCenter.default.post(name: .darkMode, object: nil)
    }
    
    static func disableDarkMode() {
        UserDefaults.standard.set(false, forKey: isDarkModeKey)
        NotificationCenter.default.post(name: .darkMode, object: nil)
    }
    
    static func addDarkModeObserver(to observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .darkMode, object: nil)
    }
    
}

extension Notification.Name {
    static let darkMode = Notification.Name("darkMode")
}
