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
    
    @MainActor
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
        date: Date,
        contact: Target.Contact?
    ) {
        Task { [weak self] in
            let count = await storage.preparedTargets().count
            let target = Target(id: String(count), name: name, date: date, connectedContact: contact, notes: [])
            await storage.add(target: target)
            await self?.addToPushSchedule(name: name, date: date)
        }
    }
    
    
    
    func delete(target: Target) {
        Task {
            await storage.delete(target: target)
        }

    }
}
