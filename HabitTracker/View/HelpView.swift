//
//  HelpView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 10.05.2025.
//

// HelpView.swift

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(HelpContent.all) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)
                                .foregroundColor(settingsVM.foregroundColor)
                            Text(section.content)
                                .font(.body)
                                .foregroundColor(settingsVM.foregroundColor.opacity(0.8))
                        }
                        .padding()
                        .background(settingsVM.isDarkMode ? Color.white.opacity(0.1) : Color.gray.opacity(0.1))

                        .cornerRadius(12)
                    }
                    // 👇 Добавляем подпись
                    Text("свайпни вниз для выхода")
                        .font(.caption)
                        .foregroundColor(settingsVM.foregroundColor.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationTitle("Справка")
            .navigationBarTitleDisplayMode(.inline)
            .background(settingsVM.backgroundColor.ignoresSafeArea())
            // Добавляем обработку свайпа вниз
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        if value.translation.height > 0 { // Свайп вниз
                            presentationMode.wrappedValue.dismiss() // Закрытие представления
                        }
                    }
            )
        }
    }
}

#Preview {
    HelpView()
        .environmentObject(SettingsViewModel())
}
