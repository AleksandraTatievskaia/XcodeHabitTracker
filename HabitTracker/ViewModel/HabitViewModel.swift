//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 31.03.2025.
//

import SwiftUI
import CoreData
import UserNotifications

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
    
    // MARK: Редактирование привычки
    @Published var editHabit: Habit?
    
    // MARK: Статус принятия уведомлений
    @Published var notificationAccess: Bool = false
    
    init(){
        requestNotificationAccess()
    }
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status 
            }
        }
    }
    
    // MARK: Добавление привычки в базу данных
    func addHabit(context: NSManagedObjectContext)async->Bool{
        // MARK: Редактирование данных
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
            // Убираем все напоминания
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:
                editHabit.notificationIDs ?? [])
        }else{
            habit = Habit(context: context)
        }
        
        habit.title = title
        habit.color = habitColor
        habit.weekDays = weekDays
        habit.isRemainderOn = isRemainderOn
        habit.remainderText = remainderText
        habit.notificationDate = remainderDate
        habit.notificationIDs = []
        
        if isRemainderOn{
            // MARK: Планируем уведомления
            if let ids = try? await scheduleNotification(){
                habit.notificationIDs = ids
                if let _ = try? context.save(){
                    return true
                }
            }
        }else{
            // MARK: Добавляем данные
            if let _ = try? context.save(){
                return true
            }
        }
      return false
    }
    
    // MARK: Добавляем уведомления
    func scheduleNotification()async throws->[String]{
        let content = UNMutableNotificationContent()
        content.title = "Напоминание о привычке"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        // Запланированные Ids
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        // MARK: Планирование уведомления
        for weekDay in weekDays {
            // Уникальный ID для каждого напоминания
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remainderDate)
            let min = calendar.component(.minute, from: remainderDate)
            let day = weekdaySymbols.firstIndex{ currentDay in
                return currentDay == weekDay
            } ?? -1
            // MARK: Так как день недели начинается с 1-7
            // Поэтому добавляем к индексу +1
            if day != -1{
                var components = DateComponents()
                components.hour = hour
                components.minute = min
                components.weekday = day + 1
                // MARK: Это вызовет уведомления в каждый выбранный день
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                // MARK: Запрос уведомлений
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
                
                // Добавляем ID
                notificationIDs.append(id)
            }
            
        }
        
        return notificationIDs
    }
    
    // MARK: Стирание контента
    func resetData(){
        title = ""
        habitColor = "Card-1"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
        editHabit = nil
    }
    
    // MARK: Удаление привычки из базы данных
    func deleteHabit(context: NSManagedObjectContext)->Bool{
        if let editHabit = editHabit {
            if editHabit.isRemainderOn{
                // Убираем все напоминания
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:
                    editHabit.notificationIDs ?? [])
            }
            context.delete(editHabit)
            if let _ = try? context.save(){
                return true 
            }
        }
        return false
        
    }
    
    // MARK: Восстановление отредавтированных данных
    func restoreEditData(){
        if let editHabit = editHabit {
            title = editHabit.title ?? ""
            habitColor = editHabit.color ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            isRemainderOn = editHabit.isRemainderOn
            remainderDate = editHabit.notificationDate ?? Date()
            remainderText = editHabit.remainderText ?? ""
        }
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

