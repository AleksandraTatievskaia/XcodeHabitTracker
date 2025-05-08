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
                .foregroundColor(.black)

                Spacer()

                Text("Тема")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(width: 60) // Чтобы "Тема" была строго по центру
            }
            .padding(.horizontal)
            .padding(.top)

           

            // Кнопки выбора темы с отступами и иконками
            VStack(spacing: 40) {
                ThemeButton(icon: "sun.max", text: "Светлая тема") {
                    settingsVM.isDarkMode = false
                }

                ThemeButton(icon: "moon.fill", text: "Тёмная тема") {
                    settingsVM.isDarkMode = true
                }
            }
            .padding(.top, 30) // Отступ сверху для кнопок

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    func ThemeButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon) // Иконка перед текстом
                    .foregroundColor(.black)
                Text(text)
                    .padding(.leading, 10) // Отступ слева для текста
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .foregroundColor(.black)
        }
    }
}

struct Theme_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
            .environmentObject(SettingsViewModel())
    }
}
