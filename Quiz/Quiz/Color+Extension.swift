//
//  UIColor+Extension.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 27.11.2024.
//
import SwiftUI

extension Color {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false)
    }
    
    static func fromData(_ data: Data) -> Color? {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        return nil
    }
}
