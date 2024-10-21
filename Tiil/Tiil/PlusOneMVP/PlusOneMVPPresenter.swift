//
//  PlusOneMVPPresenter.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

class PlusOneMVPPresenter {
    var model: PlusOneMVPModel?
    weak var viewController: PlusOneMVPViewController?
    
    init(
        viewController: PlusOneMVPViewController
    ) {
        self.viewController = viewController
    }
    
    func plusDidTap() {
        model?.addValue()
    }
    
    func valueUpdated(value: Int) {
        viewController?.updated(value: "\(value)")
    }
}
