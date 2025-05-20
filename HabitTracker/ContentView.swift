//
//  ContentView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 29.03.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        Home()
            .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingsViewModel())
    }
}
