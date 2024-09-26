//
//  Target.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation
import CoreData

struct Target: Codable, Equatable {
    let id: Int64
    let name: String
    let date: Date
}


//class TargetModel: NSManagedObject {
//    @NSManaged var name: String
//    @NSManaged var date: Date
//
//}

extension Target {
    func convertToTargetModel(context: NSManagedObjectContext) -> TargetModel {
        let model = TargetModel(context: context)
        model.name = self.name
        model.date = self.date
        model.id = self.id
        return model
    }
}

extension TargetModel {
    func convertToTarget() -> Target? {
        guard let name, let date else { return nil }
        return .init(id: id, name: name, date: date)
    }
}

extension Array where Element == TargetModel {
    func convertToTargets() -> [Target] {
        self.map { $0.convertToTarget() }.compactMap { $0 }
    }
}
