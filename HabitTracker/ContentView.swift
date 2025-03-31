//
//  ContentView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 29.03.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
