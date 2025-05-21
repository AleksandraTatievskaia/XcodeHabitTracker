import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        Home()
            .environmentObject(settingsVM)
            .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingsViewModel()) 
    }
}
