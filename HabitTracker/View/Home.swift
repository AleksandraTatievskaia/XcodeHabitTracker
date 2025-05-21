//
//  Home.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 29.03.2025.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var habits: FetchedResults<Habit>
    @StateObject var habitModel: HabitViewModel = .init()
    @State private var showSettings: Bool = false
    @State private var showMotivation = false
    @StateObject var motivationVM = MotivationViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Привычки")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .foregroundColor(settingsVM.foregroundColor)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 12) {
                        Button {
                            // Действие для кнопки с буквой М
                            showMotivation = true // Открыть MotivationView
                        } label: {
                            Text("М")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(settingsVM.iconColor)
                                .frame(width: 28, height: 28)

                        }
                        .sheet(isPresented: $showMotivation){
                            MotivationView(viewModel: motivationVM)
                            
                        }

                        Button {
                            // Действие для кнопки-шестерёнки
                            showSettings.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.title3)
                                .foregroundColor(settingsVM.iconColor)
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
                        .foregroundColor(settingsVM.foregroundColor)
                    }
                    .padding(.top,15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .padding(.vertical)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .background(settingsVM.backgroundColor.ignoresSafeArea())
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
                    .lineLimit(2)
                    .foregroundColor(settingsVM.foregroundColor)

                Image(systemName: habit.isRemainderOn ? "bell.fill" : "bell.slash")
                    .font(.callout)
                    .foregroundColor(Color(habit.color ?? "Card-1"))
                    .scaleEffect(0.9)


                Spacer()
                
                let count = (habit.weekDays?.count ?? 0)
                Text(count == 7 ? "Каждый день" : "\(count) раза в неделю ")
                    .font(.caption)
                    .foregroundColor(settingsVM.foregroundColor)
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
                            .foregroundColor(settingsVM.foregroundColor)

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
        .background(
                    settingsVM.isDarkMode ?
                        Color(.systemGray5) :
                        Color("Plain"),
                    in: RoundedRectangle(cornerRadius: 10)
                )
        
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settingsVM.isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.05), lineWidth: 1)
            )
        

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
        Home()
            .environmentObject(SettingsViewModel())
    }
}
