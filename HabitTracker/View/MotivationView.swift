//
//  MotivationView.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 10.05.2025.
//

import SwiftUI

struct MotivationView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @ObservedObject var viewModel: MotivationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showSettings: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Заголовок
            VStack(spacing: 4) {
                Text("Мотивация")
                    .font(.title3.bold())
                    .foregroundColor(settingsVM.foregroundColor)

                Text("Зарядись мотивацией на день!")
                    .font(.subheadline)
                    .foregroundColor(settingsVM.foregroundColor)
            }
            .multilineTextAlignment(.center)
            .padding(.top, 70)

            // Отображение карточки
            if !viewModel.cards.isEmpty {
                Image(uiImage: UIImage(data: viewModel.cards[viewModel.currentIndex].imageData) ?? UIImage())
                    .resizable()
                    .scaledToFill() // Заполняет всю рамку
                    .frame(width: 280, height: 420)
                    .clipShape(RoundedRectangle(cornerRadius: 20)) // Обрезка по форме
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(settingsVM.iconColor, lineWidth: 1) // Чёрная рамка
                    )
                    .clipped() // Обрезает всё, что выходит за границы
                    .padding()



                // Стрелки навигации
                HStack {
                    Button(action: { viewModel.goBack() }) {
                        VStack {
                            Image(systemName: "arrow.left")
                            Text("назад")
                        }
                    }
                    .foregroundColor(settingsVM.iconColor)

                    Spacer()

                    Button(action: { viewModel.goNext() }) {
                        VStack {
                            Image(systemName: "arrow.right")
                            Text("вперед")
                        }
                    }
                    .foregroundColor(settingsVM.iconColor)
                }
                .padding(.horizontal, 60)
            } else {
                Text("Нет карточек")
                    .foregroundColor(settingsVM.foregroundColor)
            }

            Spacer()

            // Кнопка закрытия
            Button(action: {
                dismiss()
            }) {
                Text("Закрыть")
                    .foregroundColor(settingsVM.foregroundColor)
                    .font(.body)
                    .padding()
            }
        }
        .padding(.horizontal)
        .background(settingsVM.backgroundColor.ignoresSafeArea())
    }
}

struct MotivationView_Previews: PreviewProvider {
    static var previews: some View {
        MotivationView(viewModel: MotivationViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
