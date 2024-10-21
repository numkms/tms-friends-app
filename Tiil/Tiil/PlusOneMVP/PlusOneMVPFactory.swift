//
//  PlusOneMVPFactory.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 16.10.2024.
//

import UIKit

struct PlusOneMVPFactory {
    func build() -> UIViewController {
        let model = PlusOneMVPModel(initialValue: 0)
        let viewController = PlusOneMVPViewController()
        let presenter = PlusOneMVPPresenter(viewController: viewController)
        viewController.presenter = presenter
        presenter.model = model
        return viewController
    }
}
