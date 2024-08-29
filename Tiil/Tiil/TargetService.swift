//
//  TargetService.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation

class TargetService {
    
    func createTarget(
        name: String,
        date: Date
    ) -> Target {
        let target = Target(name: name, date: date)
        Storage.shared.add(target: target)
        return target
    }
    
    var currentTargets: [Target] {
        return Storage.shared.preparedTargets()
    }
}
