//
//  QuizApp.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI

@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            QuizList().environmentObject(Storage())
//            QuizView(quiz: Quiz.makeMock())
        }
    }
}


#Preview {
    QuizList().environmentObject(Storage())
}
