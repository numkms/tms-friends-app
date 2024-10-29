//
//  AuthValidatorService.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

protocol AuthValidatorServiceProtocol {
    func isValid(login: String) -> Bool
    func isValid(password: String) -> Bool
}

class AuthValidatorService: AuthValidatorServiceProtocol {
    func isValid(login: String) -> Bool { !(login.count > 16) }
    func isValid(password: String) -> Bool { password.count >= 5 }
}
