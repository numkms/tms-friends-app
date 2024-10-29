//
//  AuthNotificator.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import Foundation

protocol AuthNotificatorProtocol {
    func notifyLogin(login: String, password: String)
    func notifyLogout()
}

class AuthNotificator: AuthNotificatorProtocol {
    func notifyLogin(login: String, password: String) {
        NotificationCenter.default.post(
            Notification(
                name: Notification.Name("userDidLogin"),
                userInfo: [
                    "userName": login,
                    "password": password
                ]
            )
        )
    }
    
    func notifyLogout() {
        NotificationCenter.default.post(
            Notification(
                name: Notification.Name("userDidLogout")
            )
        )
    }
}
