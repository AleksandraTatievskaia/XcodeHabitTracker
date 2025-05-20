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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(HelpContent.all) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)
                                .foregroundColor(.TFBG)
                            Text(section.content)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    // 👇 Добавляем подпись
                    Text("свайпни вниз для выхода")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationTitle("Справка")
            .navigationBarTitleDisplayMode(.inline)
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
}
