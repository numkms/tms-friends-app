//
//  Storage.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import Foundation



class Storage: ObservableObject {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let key = "quizes"
    
    func add(quiz: Quiz) {
        var currentQuizes = list()
        currentQuizes.append(quiz)
        guard let data = try? encoder.encode(currentQuizes) else { return }
        UserDefaults.standard.setValue(data, forKey: key)
        objectWillChange.send()
    }
    
    func list() -> [Quiz] {
        guard 
            let data = UserDefaults.standard.data(forKey: key),
            let quizes = try? decoder.decode([Quiz].self, from: data)
        else { return [] }
        return quizes
    }
}
