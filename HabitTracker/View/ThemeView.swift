//
//  ThemeView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 24.04.2025.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button("Закрыть") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top)
            .foregroundColor(.blue)

            Spacer()

            Button(action: {
                settingsVM.isDarkMode = false
            }) {
                Text("Светлая тема")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }

            Button(action: {
                settingsVM.isDarkMode = true
            }) {
                Text("Тёмная тема")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }
}
