//
//  TargetService.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation

class TargetService {
    
    let storage: TargetsStorage
    
    init(storage: TargetsStorage) {
        self.storage = storage
    }

    func createTarget(
        name: String,
        date: Date
    ) -> Target {
        let target = Target(id: String(storage.preparedTargets().count), name: name, date: date, notes: [])
        storage.add(target: target)
        return target
    }
    
    var currentTargets: [Target] {
        storage.preparedTargets()
    }
    
    func delete(target: Target) {
        storage.delete(target: target)
    }
}
