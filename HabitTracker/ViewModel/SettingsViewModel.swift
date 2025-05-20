//
//  SettingsViewModel.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 24.04.2025.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false {
        didSet {
            // Сохраняем настройку в UserDefaults
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        // Загружаем настройку из UserDefaults при инициализации
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    // Цвета интерфейса
        var backgroundColor: Color {
            isDarkMode ? .black : .white
        }

        var foregroundColor: Color {
            isDarkMode ? .white : .black
        }

        var buttonBackgroundColor: Color {
                Color(.secondarySystemBackground) // фиксированный фон, похожий на серый
            }

        var iconColor: Color {
            foregroundColor
        }
}
