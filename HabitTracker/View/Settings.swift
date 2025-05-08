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

    var body: some View {
        NavigationView {
            VStack (spacing: 60) {
                Text("Настройки")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        HStack(spacing: 12) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.title2)
                                    .foregroundColor(.black)
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
                        // Пока без действия
                    }
                }
                .sheet(isPresented: $showThemeSelector) {
                    ThemeView()
                        .environmentObject(settingsVM)
                }

                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    func SettingButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .foregroundColor(.black)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(SettingsViewModel()) 
    }
}
