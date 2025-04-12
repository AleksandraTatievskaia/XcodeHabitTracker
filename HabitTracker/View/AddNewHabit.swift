//
//  AddNewHabit.swift
//  HabitTracker
//
//  Created by Александра Татиевская on 31.03.2025.
//

import SwiftUI
import Foundation

struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    // MARK: Переменные окружения
    @Environment(\.self) var env
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                TextField("Текст", text: $habitModel.title)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .background(Color("Plain").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                // MARK: Выбор цвета привычки
                HStack(spacing: 0){
                    ForEach(1...7, id: \.self){index in
                        let color = "Card-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                if color == habitModel.habitColor{
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                }
                            })
                            .onTapGesture {
                                withAnimation {
                                    habitModel.habitColor = color 
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                // MARK: Выбор частоты
                VStack(alignment: .leading, spacing: 6) {
                    Text("Выберите частоту")
                        .font(.callout.bold())
                    let weekDays = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
                    HStack(spacing: 10) {
                        ForEach(weekDays, id: \.self) { day in
                            let isSelected = habitModel.weekDays.contains(day)
                            Text(day)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? Color(habitModel.habitColor) : Color("Plain").opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if isSelected {
                                            habitModel.weekDays.removeAll { $0 == day }
                                        } else {
                                            habitModel.weekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 15)
                }
                
                Divider()
                    .padding(.vertical,10)
                
                // Прячем если доступ к уведомлениям был отклонен пользователем
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Напоминания")
                            .fontWeight(.semibold)
                        
                        Text("Уведомления")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Toggle(isOn: $habitModel.isRemainderOn) {}
                        .labelsHidden()
                }
                .opacity(habitModel.notificationAccess ? 1 : 0)
                
                HStack(spacing: 12) {
                    Label {
                        Text(habitModel.remainderDate.formatted(date: .omitted, time:
                                .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical,12)
                    .background(Color("Plain").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .onTapGesture {
                        withAnimation {
                            habitModel.showTimePicker.toggle()
                        }
                    }
                    
                    TextField("Текст напоминания", text: $habitModel.remainderText)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(Color("Plain").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                }
                .frame(height: habitModel.isRemainderOn ? nil : 0)
                .opacity(habitModel.isRemainderOn ? 1 : 0)
                .opacity(habitModel.notificationAccess ? 1 : 0)
            }
            .animation(.easeInOut, value: habitModel.isRemainderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(habitModel.editHabit != nil ? "Редактировать привычку" : "Добавить привычку")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.black)
//                    .disabled(!habitModel.doneStatus())
//                    .opacity(habitModel.doneStatus() ? 1 : 0 )
                }
                
                // MARK: Кнопка удаления
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if habitModel.deleteHabit(context: env.managedObjectContext)
                        {
                            env.dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    .opacity(habitModel.editHabit == nil ? 0 : 1)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        Task{
                            if await habitModel.addHabit(context:
                                env.managedObjectContext){
                                env.dismiss()
                            }
                        }
                    }
                    .tint(.black)
                    .disabled(!habitModel.doneStatus())
                    .opacity(habitModel.doneStatus() ? 1 : 0.6)
                }
            }
        }
        .overlay {
            if habitModel.showTimePicker{
                ZStack{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation{
                                habitModel.showTimePicker.toggle()
                            }
                        }
                    
                    DatePicker.init("", selection:
                        $habitModel.remainderDate,displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Plain"))
                        }
                        .padding()
                    
                }
            }
        }
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.light)
    }
}
