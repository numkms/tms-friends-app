//
//  GroupPicker.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 21.08.2024.
//

import Foundation
//
//  DatePickController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 21.08.2024.
//

import Foundation
import UIKit

protocol GroupPickerControllerDelegate: AnyObject {
    func groupChanged(group: String)
    func group() -> String
    func selectableGroups() -> [String]
}

class GroupPickController: UIViewController {

    weak var delegate: GroupPickerControllerDelegate?
    
    lazy var groupPicker: UIPickerView = .init()
    
    lazy var wrapper = UIStackView()
    
    lazy var button = UIButton(primaryAction: .init(handler: { [weak self] _ in
        guard let self else { return }
        delegate?.groupChanged(group: selectedGroup)
        self.dismiss(animated: true)
    }))
    
    var selectedGroup: String = ""
    
    override func viewDidLoad() {
        groupPicker.delegate = self
        view.addSubview(wrapper)
        wrapper.addSubview(groupPicker)
        wrapper.backgroundColor = .white
        view.backgroundColor = .clear
        guard let delegate else { return }
        selectedGroup = delegate.group()
        if let selectedValue = delegate.selectableGroups().firstIndex(where: { $0 == delegate.group() }) {
            groupPicker.selectRow(selectedValue, inComponent: 0, animated: true)
        }
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        groupPicker.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Применить", for: .normal)
        button.titleLabel?.font = Fonts.headingText
        wrapper.spacing = 5
        wrapper.addArrangedSubview(groupPicker)
        wrapper.addArrangedSubview(button)
        wrapper.addArrangedSubview(UIView())
        wrapper.axis = .vertical
        
        
        NSLayoutConstraint.activate([
            wrapper.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension GroupPickController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let delegate else { return .zero }
        return delegate.selectableGroups().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.selectableGroups()[row]
    }
}
extension GroupPickController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate else { return }
        selectedGroup = delegate.selectableGroups()[row]
    }
}
