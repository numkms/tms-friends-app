//
//  PlusOneMVPModel.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

class PlusOneMVPModel {
    weak var presenter: PlusOneMVPPresenter?
    
    var currentValue: Int = 0
    
    init(initialValue: Int = 0) {
        currentValue = initialValue
    }
    
    func addValue(value: Int = 1) {
        currentValue += value
        presenter?.valueUpdated(value: currentValue)
    }
}
