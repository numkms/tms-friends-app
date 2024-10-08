//
//  PlusOneMVPPresenter.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

class PlusOneMVPPresenter {
    let model: PlusOneMVPModel
    let viewController: PlusOneMVPViewController
    
    init(model: PlusOneMVPModel, viewController: PlusOneMVPViewController) {
        self.model = model
        self.viewController = viewController
        model.presenter = self
    }
    
    func plusDidTap() {
        model.addValue()
        
    }
    
    func valueUpdated(value: Int) {
        viewController.updated(value: "\(value)")
    }
}
