//
//  QuizList.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI

class VM: ObservableObject {
    
}

struct QuizList: View {
    @EnvironmentObject
    var storage: Storage
    
    @State
    var isNewQuizFormShowed: Bool = false
    
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        NavigationView(content: {
            List {
                NavigationLink(
                    "Добавить квиз",
                    isActive: $isNewQuizFormShowed,
                    destination: {
                       CreateQuizView(hideToggle: $isNewQuizFormShowed).onAppear {
                           isTabBarHidden = true
                       }.onDisappear {
                           isTabBarHidden = false
                       }
                    }
                ).foregroundStyle(Color.blue)
                ForEach(storage.list()) { renderLink(quiz: $0) }
            }.navigationTitle("Квизы")
        })
    }
    
    func renderLink(quiz: Quiz) -> some View {
        NavigationLink(destination: QuizView(quiz: quiz)) { Text(quiz.name) }
    }
}
