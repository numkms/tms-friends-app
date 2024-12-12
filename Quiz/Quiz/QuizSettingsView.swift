//
//  QuizSettingsView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 20.11.2024.
//

import SwiftUI

/**
Сделать экран на котором можно управлять следующими аспектами квиза:
1) Отсчет времени (ограничение по времени) (да, нет)
2) Количество времени на ответ
3) Рандомная сортировка ответов (да или нет)
4) Цветовая тема (....)
 **/

struct QuizSettingsView: View {
    static let maximumQuestionTime: Float = 100
    
    @EnvironmentObject
    var storage: Storage
    
    var quiz: Quiz
    
    @State var isSecondsCountEnabled: Bool = true
    @State var questionTimeCoefficient: Float = 1
    @State var answersRandomOrder: Bool = false
    @State var backgroundColor: Color = .white
    

    var currentSelectedQuestionTime: Int {
        Int(Self.maximumQuestionTime * questionTimeCoefficient)
    }
    
    var body: some View {
        List {
            HStack {
                Toggle(isOn: $answersRandomOrder, label: {
                    Text("Рандомная сортировка ответов")
                })
            }
            ColorPicker("Цвет фона", selection: $backgroundColor)
            HStack {
                Toggle(isOn: $isSecondsCountEnabled, label: {
                    Text("Отсчет времени")
                })
            }
            if isSecondsCountEnabled {
                VStack {
                    HStack {
                        ZStack {
                            Text("Количество секунд").offset(y: 18)
                            Text("\(currentSelectedQuestionTime) cек").offset(y: -18)
                            Slider(value: $questionTimeCoefficient) {
                                Text("Количество секунд")
                            }
                        }.padding()
                    }
                }
            }
        }
        
        Button("Сохранить") {
            storage.update(settings: .init(
                isSecondsCountEnabled: isSecondsCountEnabled,
                questionTime: currentSelectedQuestionTime,
                answersRandomOrder: answersRandomOrder,
                backgroundColor: backgroundColor.toData()
            ), for: quiz)
        }
    }
}

//
//#Preview {
//    QuizSettingsView(quiz: .makeMock())
//}
