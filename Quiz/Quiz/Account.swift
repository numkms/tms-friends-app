//
//  Account.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 02.12.2024.
//

import Foundation

protocol AnalyticsProtocol: AnyObject {
    func send(event: String, params: [String: String])
}

class Analytics: AnalyticsProtocol {
    func send(event: String, params: [String : String]) {
        guard let url = URL(string: "http://myanalytics.com/api") else { return }
        var request = URLRequest(url: url)
        request.httpBody = try? JSONEncoder().encode(params)
        URLSession.shared.dataTask(with: request)
    }
}

class AnalyticsMock: AnalyticsProtocol {
    var sendWasCalled: Int = 0
    var sendParams: (event: String, params: [String: String])!
    
    func send(event: String, params: [String : String]) {
        sendWasCalled += 1
        self.sendParams = (event, params)
    }
}

class Account {
    typealias Login = String
    typealias Password = String
    
    private let maxUsernameLength = 8
    private let minimumPasswordLength = 8
    private let analytics: AnalyticsProtocol
    
    private var users: [Login: Password]
    
    init(
        users: [String: String],
        analytics: AnalyticsProtocol = Analytics()
    ) {
        self.users = users
        self.analytics = analytics
    }
    
    enum RegisterError: Error {
        case userExist
        case whitespaces
        case toLongUsername
        case toShortPassword
    }
    
    func login(login: String, password: String) -> Bool {
        if let userPassword = users[login], userPassword == password  {
            analytics.send(event: "login_success", params: [:])
            return true
        }
        analytics.send(event: "login_failed", params: [:])
        return false
    }
    
    func register(login: Login, password: Password) -> Result<Login, RegisterError> {
        if let error = validate(login: login, password: password) {
            if error == .userExist {
                analytics.send(event: "register_failed", params: ["reason": "userExist"])
            } else {
                analytics.send(event: "register_failed", params: [:])
            }
            
            return .failure(error)
        }
        users[login] = password
        analytics.send(event: "register_success", params: [:])
        return .success(login)
    }
    
    private func validate(login: Login, password: Password) -> RegisterError? {
        if let _ = users[login] {
            return .userExist
        }
        if String(repeating: " ", count: login.count) == login {
            return .whitespaces
        }
        
        if login.count > maxUsernameLength {
            return .toLongUsername
        }
        
        if password.count < minimumPasswordLength {
            return .toShortPassword
        }
        return nil
    }
}
