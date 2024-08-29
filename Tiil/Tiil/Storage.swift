//
//  Storage.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation

class Storage {
    static let shared = Storage()
    
    var targets: [Target] = []
    
    func add(target: Target) {
        targets.append(target)
    }
    
    func preparedTargets() -> [Target] {
        return targets.reversed()
    }
}
