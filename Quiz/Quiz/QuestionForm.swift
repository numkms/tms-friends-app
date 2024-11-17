//
//  QuestionForm.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI
import Combine

struct Answer: Identifiable, Codable {
    var id: Int
    var text: String
    var isCorrect: Bool
}

class QuestionFormViewModel: ObservableObject {
    @Published
    var question: String = ""
    
    @Published
    var answers: [Answer] = [
        .init(id: 1, text: "", isCorrect: true)
    ]
    
    func addAnswer() {
        let id = (answers.last?.id ?? 0) + 1
        answers.append(.init(
            id: id,
            text: "", 
            isCorrect: false)
        )
    }
}

struct QuestionForm: View {
    @State
    var listeners: [AnyCancellable] = []
    
    @StateObject
    var viewModel: QuestionFormViewModel = .init()
    
    @ObservedObject
    var quizViewModel: CreateQuizViewModel
    
    @Binding
    var hideToggle: Bool
    
    var body: some View {
        ScrollView {
            Image("cat", bundle: .main)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                
            VStack(alignment: .leading) {
                HStack {
                    Button("Добавить ответ") {
                        viewModel.addAnswer()
                    }
                    Button("Сохранить") {
                        quizViewModel.add(question: .init(
                            question: viewModel.question,
                            answers: viewModel.answers
                        ))
                        hideToggle = false
                    }
                }
                Text("Вопрос")
                    .lineLimit(.max)
                    .foregroundStyle(Gradient(colors: [Color.red.opacity(0.3), Color.red]))
                    .font(.system(size: 35))
                    
                TextField(text: $viewModel.question, prompt: Text("Введите свой вопрос")) {
                    EmptyView()
                }
                Text("Ответы")
                ForEach($viewModel.answers) { $item in
                    makeAnswerCell(answer: $item)
                }
            }
            .padding(10)
        }
        .background(Gradient(colors: [Color.blue.opacity(0.3), Color.blue]))
    }
    
    @ViewBuilder
    func makeAnswerCell(answer: Binding<Answer>) -> some View {
        HStack {
            TextField("Ответ \(answer.id)", text: answer.text)
            Toggle("", isOn: answer.isCorrect)
        }
        
    }
}

