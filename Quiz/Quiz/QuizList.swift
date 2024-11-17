//
//  QuizList.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI


struct QuizList: View {
    @EnvironmentObject
    var storage: Storage
    
    @State
    var isNewQuizFormShowed: Bool = false
    
    var body: some View {
        NavigationView(content: {
            List {
                NavigationLink("Добавить квиз", isActive: $isNewQuizFormShowed, destination: {
                    CreateQuizView(hideToggle: $isNewQuizFormShowed)
                }).foregroundStyle(Color.blue)
                ForEach(storage.list()) { item in
                    NavigationLink(
                        destination: Text(item.items.reduce("", { partialResult, item in
                        item.answers.reduce("") { partialResult, answer in
                            partialResult + ", " + answer.text
                        }
                    }))) { Text(item.name) }
                }
            }.navigationTitle("Квизы")
        })
    }
}
