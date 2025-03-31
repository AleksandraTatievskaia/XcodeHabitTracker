//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 31.03.2025.
//

import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    // MARK: Свойства новой привычки
    @Published var addNewHabit: Bool = false
    
    @Published var title: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    // MARK: Выбор времени напоминания
    @Published var showTimePicker: Bool = false
    
    // MARK: Добавление привычки в базу данных
    func addHabit(context: NSManagedObjectContext)->Bool{

        return false
    }
    
    // MARK: Стирание контента
    func resetData(){
         title = ""
        habitColor = "Card-1"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
    }
    
    // MARK: Статус кнопки готово
    func doneStatus()->Bool{
        let remainderStatus = isRemainderOn ? remainderText == "" : false
        
        if title == "" || weekDays.isEmpty || remainderStatus{
            return false
        }
        return true
    }
}

