//
//  CreateTargetInteractor.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import Foundation

class CreateTargetInteractor {

    let presenter: CreateTargetPresenter
    
    weak var createDelegate: CreateTargetViewControllerDelegate?
    
    init(presenter: CreateTargetPresenter) {
        self.presenter = presenter
    }
    
    
    func createButttonDidTap(with name: String, date: Date) {
        self.createDelegate?.didCreateTarget(name: name, date: date)
        self.presenter.close()
    }
}
