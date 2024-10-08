//
//  TargetService.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation
import UserNotifications

class TargetService {
    
    let storage: TargetsStorage
    
    init(storage: TargetsStorage) {
        self.storage = storage
    }
    
    private func addToPushSchedule(name: String, date: Date) {
        let message = "\(name) наступило! Отпразднуйте с нами! 🥳"
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = .defaultCritical
        var dateComponents = Calendar.current.dateComponents([
            .year, .month, .day, .hour, .minute, .second
        ], from: date)
        let triger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "\(name)",
            content: content,
            trigger: triger
        )
        let center = UNUserNotificationCenter.current()
        center.add(request)
        /*
         center.removePendingNotificationRequests(withIdentifiers: [""])
         */
    }

    func createTarget(
        name: String,
        date: Date
    ) -> Target {
        let target = Target(id: String(storage.preparedTargets().count), name: name, date: date, notes: [])
        storage.add(target: target)
        addToPushSchedule(name: name, date: date)
        return target
    }
    
    var currentTargets: [Target] {
        storage.preparedTargets()
    }
    
    func delete(target: Target) {
        storage.delete(target: target)
    }
}
