//
//  Settings.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 24.04.2025.
//

import SwiftUI
import UIKit


struct Settings: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showThemeSelector = false
    @State private var showNotificationAlert = false
    @EnvironmentObject var settingsVM: SettingsViewModel
    @State private var showHelp = false

    var body: some View {
        NavigationView {
            VStack (spacing: 60) {
                Text("Настройки")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                    .overlay(alignment: .trailing) {
                        HStack(spacing: 12) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.title2)
                                    .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                                    .padding()
                            }
                            Spacer()
                            
                        }
                        
                    }

                VStack(spacing: 40) {
                    SettingButton(icon: "bell", text: "Уведомления") {
                        showNotificationAlert = true
                    }
                    .alert(isPresented: $showNotificationAlert) {
                        Alert(
                            title: Text("Открыть настройки"),
                            message: Text("Перейдите в раздел «Уведомления» и включите разрешения для этого приложения."),
                            primaryButton: .default(Text("Открыть настройки")) {
                                if let url = URL(string: UIApplication.openSettingsURLString),
                                   UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            },
                            secondaryButton: .cancel(Text("Отмена"))
                        )
                    }


                    SettingButton(icon: "sun.max", text: "Изменить тему") {
                        showThemeSelector.toggle()
                    }

                    SettingButton(icon: "questionmark.circle", text: "Справка") {
                        showHelp.toggle()
                    }
                    .sheet(isPresented: $showHelp) {
                        HelpView()
                    }

                }
                .sheet(isPresented: $showThemeSelector) {
                    ThemeView()
                        .environmentObject(settingsVM)
                }

                Spacer()
            }
            .padding()
            .background(settingsVM.isDarkMode ? Color.black : Color.white)
        }
        .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
    }

    @ViewBuilder
    func SettingButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                Text(text)
                    .padding(.leading, 10)
                    .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(settingsVM.buttonBackgroundColor)
            )
            .foregroundColor(.black)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            // Превью для светлой темы
            Settings()
                .environmentObject(SettingsViewModel())
                .preferredColorScheme(.light)
            // Превью для тёмной темы
            Settings()
                .environmentObject({
                    let vm = SettingsViewModel()
                    vm.isDarkMode = true
                    return vm
                }())
                .preferredColorScheme(.dark)
            
            
        }
        
        
       
    }
}
