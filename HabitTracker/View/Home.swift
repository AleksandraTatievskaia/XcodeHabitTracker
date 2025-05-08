//
//  Home.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 29.03.2025.
//

import SwiftUI

struct Home: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var habits: FetchedResults<Habit>
    @StateObject var habitModel: HabitViewModel = .init()
    @State private var showSettings: Bool = false
    @StateObject var settingsVM = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Привычки")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 12) {
                        Button {
                            // Действие для кнопки с буквой М
                        } label: {
                            Text("М")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.TFBG)
                                .frame(width: 28, height: 28)
                            
                        }
                        
                        Button {
                            showSettings.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 10)
                }
            
            // Делаем кнопку добавления по центру, когда привычек нет
            ScrollView(habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    ForEach(habits){habit in
                        HabitCardView(habit: habit)
                        
                    }
                    // MARK: Add Habit Button
                    Button {
                        habitModel.addNewHabit.toggle()
                    } label: {
                        Label {
                            Text("Новая привычка")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.black)
                    }
                    .padding(.top,15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .padding(.vertical)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .sheet(isPresented: $habitModel.addNewHabit) {
            // MARK: Стираем весь существующий контент
            habitModel.resetData()
        } content: {
            AddNewHabit()
                .environmentObject(habitModel)
        }
        
        .sheet(isPresented: $showSettings) {
            Settings()
                .environmentObject(settingsVM)
        }
        
    }
    
    // MARK: Habit Card View
    @ViewBuilder
    func HabitCardView(habit: Habit)->some View{
        VStack(spacing: 6){
            HStack{
                Text(habit.title ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.color ?? "Card-1"))
                    .scaleEffect(0.9)
                    .opacity(habit.isRemainderOn ? 1 : 0)
                
                Spacer()
                let count = (habit.weekDays?.count ?? 0)
                Text(count == 7 ? "Каждый день" : "\(count) раза в неделю ")
                    .font(.caption)
                    .foregroundColor(.TFBG)
            }
            .padding(.horizontal,10)
            
            // MARK: Отображаем текущую неделю и помечаем активные даты привычек (с понедельника)
            let calendar = Calendar.current
            let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let weekSymbols = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
            let activeWeekDays = habit.weekDays ?? []
            
            let activePlot = weekSymbols.indices.compactMap { index -> (String, Date) in
                let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                return (weekSymbols[index], currentDate!)
            }
            
            HStack(spacing: 0) {
                ForEach(activePlot.indices, id: \.self) { index in
                    let item = activePlot[index]
                    
                    VStack(spacing: 6) {
                        // MARK: Сокращение названия дня
                        Text(item.0.prefix(3))
                            .font(.caption)
                            .foregroundColor(.TFBG)
                        
                        // MARK: Проверка: выбран ли день
                        let status = activeWeekDays.contains(item.0)
                        
                        Text(getDate(date: item.1))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color(habit.color ?? "Card-1"))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color("Plain"), in: RoundedRectangle(cornerRadius: 10))
        
        .onTapGesture {
            // MARK: Редактирование привычек
            habitModel.editHabit = habit
            habitModel.restoreEditData()
            habitModel.addNewHabit.toggle()
        }
    }
            
        
    // MARK: Формат даты
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
