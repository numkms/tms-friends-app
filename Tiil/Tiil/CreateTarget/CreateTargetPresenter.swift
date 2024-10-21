//
//  CreateTargetPresenter.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import Foundation
// VIP
// - View
// - Interactor 
// - Presenter
class CreateTargetPresenter {
    var interactor: CreateTargetInteractor?
    weak var view: CreateTargetViewController?
    let router: CreateTargetRouter
    
    
    init(
        router: CreateTargetRouter
    ) {
        self.router = router
    }
    
    func createButttonDidTap(with name: String, date: Date, contact: Target.Contact?){
        self.interactor?.createButttonDidTap(with: name, date: date, contact: contact)
    }
    
    func close() {
        guard let view else { return }
        self.router.dismiss(viewController: view)
    }
}
