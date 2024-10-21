//
//  Target.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation
import CoreData

struct Target: Codable, Equatable {
    struct Contact: Codable, Equatable {
        let name: String
        let phone: String
    }
    let id: String
    let name: String
    let date: Date
    let connectedContact: Contact?
    let notes: [Note]
}

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
        return .init(
            id: id!,
            name: name,
            date: date,
            connectedContact: nil,
            notes: notes?.map { dbNote -> Note? in
                guard let dbNote = dbNote as? TargetNote else {
                    return nil
                }

                return Note(
                    message: dbNote.message!,
                    createdAt: dbNote.createdAt!
                )
            }.compactMap { $0 }  ?? []
        )
    }
}

extension Array where Element == TargetModel {
    func convertToTargets() -> [Target] {
        self.map { $0.convertToTarget() }.compactMap { $0 }
    }
}
