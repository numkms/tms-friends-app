//
//  AuthService.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct User {
    let name: String
}

enum AuthError: Error {
    case wrongPassword
}

protocol AuthProtocol {
    func auth(login: String, password: String) async -> Result<User, AuthError>
    func logout()
}

protocol UserStorageProtocol {
    var users: [String: String] { get }
}

class UserStorageService: UserStorageProtocol {
    let users: [String: String] = [
        "nikolay@mail.ru": "qwergunsn",
        "vladimir@gmail.com": "123566",
        "nikita@yahoo.com": "JKDIwqi1dnni1@22n##",
        "1": "1",
    ]
}

actor AuthServiceFirebase: AuthProtocol {
    func auth(
        login: String,
        password: String
    ) async -> Result<User, AuthError> {
        do {
            let result = try await Auth.auth().createUser(withEmail: login, password: password)
            return .success(.init(name: result.user.uid))
        } catch {
            return .failure(.wrongPassword)
        }
    }
    
    nonisolated func logout() {
        
    }
}

class AuthService: AuthProtocol {
    let usersStorage: UserStorageProtocol
    let authNotificator: AuthNotificatorProtocol
    
    init(
        usersStorage: UserStorageProtocol,
        authNotificator: AuthNotificatorProtocol
    ) {
        self.usersStorage = usersStorage
        self.authNotificator = authNotificator
    }
    
    func auth(login: String, password: String) -> Result<User, AuthError> {
        return .success(.init(name: "DummyUser"))
        guard
            let userPassword = usersStorage.users[login],
            password == userPassword
        else { return .failure(.wrongPassword) }
        authNotificator.notifyLogin(login: login, password: password)
        return .success(.init(name: login))
    }
    
    
    func logout() {
        authNotificator.notifyLogout()
    }
}
