//
//  RealmTarget.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 30.09.2024.
//

import RealmSwift
import Foundation

class RealmTarget: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted var contactName: String?
    @Persisted var contactPhone: String?
}
