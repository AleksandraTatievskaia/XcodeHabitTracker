//
//  ThemeView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 3.05.2025.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        VStack {
            // Верхняя панель с заголовком и кнопкой "Закрыть"
            HStack {
                Button("Закрыть") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.primary)

                Spacer()

                Text("Тема")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(width: 60)
            }
            .padding(.horizontal)
            .padding(.top)

            // Кнопки выбора темы
            VStack(spacing: 40) {
                ThemeButton(
                    icon: "sun.max",
                    text: "Светлая тема",
                    isSelected: !settingsVM.isDarkMode
                ) {
                    settingsVM.isDarkMode = false
                }

                ThemeButton(
                    icon: "moon.fill",
                    text: "Тёмная тема",
                    isSelected: settingsVM.isDarkMode
                ) {
                    settingsVM.isDarkMode = true
                }
            }
            .padding(.top, 30)

            Spacer()
        }
        .id(settingsVM.isDarkMode) // 💡 Добавлено
        .padding()
        .background(Color(.systemBackground))
        .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
        
    }

    @ViewBuilder
    func ThemeButton(icon: String, text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                Text(text)
                    .foregroundColor(.primary)
                    .padding(.leading, 10)
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(settingsVM.isDarkMode ? .white : .black)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(settingsVM.buttonBackgroundColor)
            )
        }
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Превью для светлой темы
            ThemeView()
                .environmentObject(SettingsViewModel())
                .preferredColorScheme(.light)
            
            // Превью для тёмной темы
            ThemeView()
                .environmentObject({
                    let vm = SettingsViewModel()
                    vm.isDarkMode = true
                    return vm
                }())
                .preferredColorScheme(.dark)
        }
    }
}
