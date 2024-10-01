//
//  Note.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 30.09.2024.
//

import Foundation

struct Note: Codable, Equatable {
    let message: String
    let createdAt: Date
}
