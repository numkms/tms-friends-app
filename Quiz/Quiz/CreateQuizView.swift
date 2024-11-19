//
//  CreateQuizView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 13.11.2024.
//

import SwiftUI

struct QuizItem: Codable, Identifiable {
    var id: String { question }
    let question: String
    let answers: [Answer]
}

struct Quiz: Codable, Identifiable {
    var id: String { name }
    let name: String
    let items: [QuizItem]
    
    #if DEBUG
    static func makeMock() -> Quiz {
        return .init(name: "Ну что там с деньгами?", items: [
            .init(question: "С какими деньгами? 1", answers: [
                .init(id: 0, text: "Который я вложил", isCorrect: true),
                .init(id: 1, text: "Что?", isCorrect: false),
                .init(id: 2, text: "Где?", isCorrect: false),
                .init(id: 2, text: "Когда?", isCorrect: false)
            ]),
            .init(question: "С какими деньгами? 2", answers: [
                .init(id: 0, text: "Который я вложил", isCorrect: true),
                .init(id: 1, text: "Что?", isCorrect: false),
                .init(id: 2, text: "Где?", isCorrect: false),
                .init(id: 2, text: "Когда?", isCorrect: false)
            ]),
            .init(question: "С какими деньгами? 3", answers: [
                .init(id: 0, text: "Который я вложил", isCorrect: true),
                .init(id: 1, text: "Что?", isCorrect: false),
                .init(id: 2, text: "Где?", isCorrect: false),
                .init(id: 2, text: "Когда?", isCorrect: false)
            ])
        ])
    }
    #endif
}

class CreateQuizViewModel: ObservableObject {
    @Published
    var name: String = ""
    
    @Published
    var questions: [QuizItem] = []
    
    func add(question: QuizItem) {
        questions.append(question)
    }
    
    func save(
        storage: Storage
    ) { 
        storage.add(quiz: .init(
            name: name,
            items: questions
        ))
    }
}


struct CreateQuizView: View {
    
    @EnvironmentObject
    var storage: Storage
    
    @StateObject
    var viewModel: CreateQuizViewModel = .init()
    
    @State
    var isQuestionFormShowed: Bool = false
    
    @Binding
    var hideToggle: Bool
    
    var body: some View {
        VStack {
            TextField(text: $viewModel.name, prompt: Text("Введите название квиза")) {
                EmptyView()
            }
            Button("Добавить вопрос") {
                 isQuestionFormShowed = true
            }
            Button("Сохранить") {
                viewModel.save(storage: storage)
                hideToggle = false
            }
            Text("Вопросы")
            List(viewModel.questions) { item in
                HStack {
                    Text(item.question)
                    Spacer()
                    Text("\(item.answers.count)")
                }
            }
        }.sheet(
            isPresented: $isQuestionFormShowed,
            content: {
                QuestionForm(
                    quizViewModel: viewModel,
                    hideToggle: $isQuestionFormShowed
                )
        })
        
    }
}

