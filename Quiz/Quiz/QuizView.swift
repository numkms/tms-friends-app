//
//  QuizView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 18.11.2024.
//
import SwiftUI

struct QuizView: View {
    var quiz: Quiz
    
    var body: some View {
        VStack {
            Text(quiz.name).font(.title)
            Text("Квиз на \(quiz.items.count) вопросов").foregroundStyle(Color.gray)
            Spacer()
            NavigationLink(destination: {
                QuizGameView(quiz: quiz)
            }) {
                Text("Начать")
            }
            NavigationLink(destination: {
                QuizSettingsView(
                    quiz: quiz,
                    isSecondsCountEnabled: quiz.settings.isSecondsCountEnabled,
                    questionTimeCoefficient: Float(quiz.settings.questionTime) / QuizSettingsView.maximumQuestionTime,
                    answersRandomOrder: quiz.settings.answersRandomOrder,
                    backgroundColor: .white
                )
            }) {
                Text("Настройки")
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    QuizView(quiz: Quiz.makeMock())
}
#endif
