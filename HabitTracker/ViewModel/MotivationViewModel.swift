//
//  MotivationViewModel.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 10.05.2025.
//

import SwiftUI
import CoreData

class MotivationViewModel: ObservableObject {
    @Published var cards: [MotivationCardModel] = []
    @Published var currentIndex: Int = 0

    let context = PersistenceController.shared.container.viewContext

    init() {
        fetchCards()
        if cards.isEmpty {
            preloadDefaultCards()  // Загружаем изображения по умолчанию, если их нет в базе данных
            fetchCards()  // Заново загружаем карточки после их добавления
        }
    }

    // Получаем все карточки из базы данных Core Data
    func fetchCards() {
        let request: NSFetchRequest<MotivationCardEntity> = MotivationCardEntity.fetchRequest()
        if let result = try? context.fetch(request) {
            self.cards = result.compactMap {
                guard let data = $0.imageName else { return nil }
                return MotivationCardModel(id: $0.objectID, imageData: data)
            }
        }
    }

    // Загружаем карточки из ассетов, если они еще не сохранены в базе данных
    func preloadDefaultCards() {
        let imageNames = (1...20).map { "card\($0)" }  // Перебираем изображения, например, card1, card2, ...
        
        for name in imageNames {
            if let uiImage = UIImage(named: name), let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                let newCard = MotivationCardEntity(context: context)
                newCard.imageName = imageData  // Сохраняем изображение в Core Data
            }
        }
        try? context.save()  // Сохраняем изменения в базе данных
    }

    // Переход к следующей карточке
    // Переход к следующей карточке (по кругу)
    func goNext() {
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex + 1) % cards.count
    }

    // Переход к предыдущей карточке (по кругу)
    func goBack() {
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex - 1 + cards.count) % cards.count
    }

}
