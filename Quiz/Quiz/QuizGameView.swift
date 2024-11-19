//
//  QuizGameView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 18.11.2024.
//

import SwiftUI
import Combine

final class QuizGameViewViewModel: ObservableObject {
    enum Config {
        static let defaultTimerValue: TimeInterval = 20
    }
    
    @Published
    var currentQuestion: QuizItem?
    var currentQuestionIndex: CurrentValueSubject<Int, Never> = .init(0)
    var subscribers: [AnyCancellable] = []
    var timerSubscribes: [AnyCancellable] = []
    @Published
    var secondsLeft: TimeInterval = 0
        
    func start(quiz: Quiz) {
        currentQuestionIndex.sink { [weak self] index in
            guard quiz.items.count > index else {
                self?.gameover()
                return
            }
            self?.currentQuestion = quiz.items[index]
        }.store(in: &subscribers)
        invalidateTimer()
    }
    
    func invalidateTimer() {
        timerSubscribes.removeAll()
        secondsLeft = Config.defaultTimerValue
        Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
        .sink { [weak self] value in
            self?.handleTimerTick()
        }.store(in: &timerSubscribes)
    }
    
    func handleTimerTick() {
        secondsLeft -= 1
        if secondsLeft <= 0 {
            next()
        }
    }
    
    func gameover() {
        
    }
    
    func answer(answer: Answer) {
        next()
    }
    
    func next() {
        currentQuestionIndex.send(currentQuestionIndex.value + 1)
        invalidateTimer()
    }
}

struct QuizGameView: View {
    var quiz: Quiz
    
    @StateObject
    var viewModel: QuizGameViewViewModel = .init()
    
    var body: some View {
        HStack {
            if let currentQuestion = viewModel.currentQuestion {
                VStack {
                    Text("Вопрос").font(.title)
                    Text("Секунд осталось: \(viewModel.secondsLeft)")
                    Text(currentQuestion.question).font(.title3)
                    ForEach(currentQuestion.answers) { answer in
                        Button(answer.text) {
                            viewModel.answer(answer: answer)
                        }
                    }
                }
            } else {
                Text("Нет вопроса")
            }
        }.onAppear {
            viewModel.start(quiz: quiz)
        }
        
        
    }
}
#if DEBUG
#Preview {
    QuizGameView(
        quiz: Quiz.makeMock()
    )
}
#endif
