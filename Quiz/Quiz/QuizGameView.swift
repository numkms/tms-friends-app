//
//  QuizGameView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 18.11.2024.
//

import SwiftUI
import Combine

final class QuizGameViewViewModel: ObservableObject {
    enum Config {}
    
    @Published
    var currentQuestion: QuizItem?
    @Published
    var secondsLeft: TimeInterval = 0
    @Published
    var settings: QuizSettings?
    @Published
    var currentAnswers: [Answer] = []
    @Published
    var isGameOver: Bool = false
    
    var currentQuestionIndex: CurrentValueSubject<Int, Never> = .init(0)
    var subscribers: [AnyCancellable] = []
    var timerSubscribes: [AnyCancellable] = []
    var backgroundColor: Color? {
        if let colorData = settings?.backgroundColor {
            return Color.fromData(colorData)
        }
        return Color.white
    }

    var resultAnswers: [QuizItem: Answer?] = [:]

    func start(quiz: Quiz) {
        settings = quiz.settings
        currentQuestionIndex.sink { [weak self] index in
            guard let self else { return }
            indexChanged(index, quiz: quiz)
        }.store(in: &subscribers)
        
    }
    
    func indexChanged(_ index: Int, quiz: Quiz) {
        guard quiz.items.count > index else {
            gameover()
            return
        }
        currentQuestion = quiz.items[index]
        currentAnswers = (settings?.answersRandomOrder == true ? currentQuestion?.answers.shuffled() : currentQuestion?.answers) ?? []
        guard quiz.settings.isSecondsCountEnabled else { return }
        invalidateTimer()
    }
    
    func invalidateTimer() {
        guard let questionTime = settings?.questionTime else { return }
        timerSubscribes.removeAll()
        secondsLeft = .init(questionTime)
        
        Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
        .sink { [weak self] value in
            self?.handleTimerTick()
        }.store(in: &timerSubscribes)
    }
    
    func handleTimerTick() {
        secondsLeft -= 1
        if secondsLeft <= 0 {
            guard let currentQuestion else { return }
            resultAnswers[currentQuestion] = nil
            next()
        }
    }
    
    func gameover() {
        timerSubscribes.removeAll()
        isGameOver = true
    }
    
    func answer(answer: Answer) {
        guard let currentQuestion else { return }
        resultAnswers[currentQuestion] = answer
        next()
    }
    
    func next() {
        currentQuestionIndex.send(currentQuestionIndex.value + 1)
    }
}

struct QuizGameView: View {
    var quiz: Quiz
    
    @StateObject
    var viewModel: QuizGameViewViewModel = .init()
    
    var body: some View {
        if viewModel.isGameOver == false {
            gameView
        } else {
            resultView
        }
    }
    
    @ViewBuilder
    var resultView: some View {
        List {
            ForEach(quiz.items, id: \.id) { item in
                Section(
                    content: {
                        let currentItemAnswer = viewModel.resultAnswers[item]
                        ForEach(item.answers, id: \.id) { answer in
                            let isCurrentAnswerWasAnswered = currentItemAnswer == answer
                            let isCorrectAnswerWasAnswered = answer.isCorrect
                            let (color, textColor) = switch (isCorrectAnswerWasAnswered, isCurrentAnswerWasAnswered) {
                            case (true, true): (Color.green, Color.white)
                            case (true, false): (Color.blue, Color.white)
                            case (false, true): (Color.red, Color.white)
                            default: (Color.white, Color.black)
                            }
                            ZStack {
                                HStack {
                                    Text(answer.text)
                                    Spacer()
                                    color.mask(Circle()).frame(width: 25, height: 25)
                                }
                            }.ignoresSafeArea()
                        }
                    },
                    header: {
                        Text(item.question).font(.system(size: 20))
                    },
                    footer: {
                        if item == quiz.items.last {
                            VStack {
                                Text("Памятка")
                                HStack {
                                    Color.green.mask(Circle()).frame(width: 25, height: 25)
                                    Text("Вы ответили правильно")
                                    Spacer()
                                }
                                
                                HStack {
                                    Color.red.mask(Circle()).frame(width: 25, height: 25)
                                    Text("Вы ответили не правильно")
                                    Spacer()
                                    
                                }
                                
                                HStack {
                                    Color.blue.mask(Circle()).frame(width: 25, height: 25)
                                    
                                    Text("Вы ответили не правильно, правильный ответ")
                                    Spacer()
                                }
                            }
                            
                        }
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    var gameView: some View {
        ZStack {
            viewModel.backgroundColor?.ignoresSafeArea()
            HStack {
                if let currentQuestion = viewModel.currentQuestion {
                    VStack {
                        Text("Вопрос").font(.title)
                        if let settings = viewModel.settings, settings.isSecondsCountEnabled,
                            let formatted = viewModel.secondsLeft.asFormattedSeconds() {
                            Text("Осталось: \(formatted)")
                        }
                        Text(currentQuestion.question).font(.title3)
                        ForEach(viewModel.currentAnswers) { answer in
                            Button(answer.text) {
                                viewModel.answer(answer: answer)
                            }
                        }
                    }
                } else {
                    Text("Нет вопроса")
                }
            }
            .onAppear {
                viewModel.start(quiz: quiz)
            }
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

private extension TimeInterval {
    func asFormattedSeconds() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        formatter.calendar?.locale = .init(identifier: "RU-ru")
        return formatter.string(from: self)
    }
}
