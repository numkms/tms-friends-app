//
//  CreateTargetRouter.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import Foundation
import UIKit

class CreateTargetRouter {
    static let shared = CreateTargetRouter()
    
    func build(
        delegate: CreateTargetViewControllerDelegate?
    ) -> UIViewController {
        let view = CreateTargetViewController()
        let presenter = CreateTargetPresenter(router: self)
        let interactor = CreateTargetInteractor(presenter: presenter, networkClient: .shared)
        interactor.createDelegate = delegate
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        view.modalPresentationStyle = .pageSheet
        view.sheetPresentationController?.detents = [.medium()]
        return view
    }
    
    func present(
        on viewController: UIViewController & CreateTargetViewControllerDelegate
    ) {
        let view = build(delegate: viewController)
        viewController.present(view, animated: true)
    }
    
    
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
}
