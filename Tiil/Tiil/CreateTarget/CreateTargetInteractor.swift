//
//  CreateTargetInteractor.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import Foundation

class CreateTargetInteractor {

    weak var presenter: CreateTargetPresenter?
    let networkClient: URLSession
    
    weak var createDelegate: CreateTargetViewControllerDelegate?
    
    init(
        presenter: CreateTargetPresenter,
        networkClient: URLSession
    ) {
        self.presenter = presenter
        self.networkClient = networkClient
    }
    
    
    func createButttonDidTap(with name: String, date: Date, contact: Target.Contact?) {
        self.createDelegate?.didCreateTarget(name: name, date: date, contact: contact)
        self.presenter?.close()
    }
    
    
    func request() {
    
    }
}

