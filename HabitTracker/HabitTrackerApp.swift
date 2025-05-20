//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 29.03.2025.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @StateObject var settingsVM = SettingsViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsVM) // подключение настроек ко всему приложению
                
        }
    }
}
