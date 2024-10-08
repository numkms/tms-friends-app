//
//  CreateTargetPresenter.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import Foundation

class CreateTargetPresenter {
    var interactor: CreateTargetInteractor?
    weak var view: CreateTargetViewController?
    let router: CreateTargetRouter
    
    
    init(
        router: CreateTargetRouter
    ) {
        self.router = router
    }
    
    func createButttonDidTap(with name: String, date: Date) {
        self.interactor?.createButttonDidTap(with: name, date: date)
    }
    
    func close() {
        guard let view else { return }
        self.router.dismiss(viewController: view)
    }
}
