//
//  AuthFactory.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import UIKit

class AuthFactory {
    let authService: AuthProtocol
    
    init(authService: AuthProtocol) {
        self.authService = authService
    }
    
    func build() -> UIViewController {
        let authViewController = AuthViewController(
            authService: authService,
            authValidator: AuthValidatorService()
        )
        return authViewController
    }
}
