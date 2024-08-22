//
//  DatePickController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 21.08.2024.
//

import Foundation
import UIKit

protocol DatePickControllerDelegate: AnyObject {
    func dateChanged(date: Date)
    func date() -> Date?
}

class DatePickController: UIViewController {

    weak var delegate: DatePickControllerDelegate?
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        datePicker.datePickerMode = .date
        datePicker.addAction(UIAction(handler: {[weak self] _ in
            guard let self else { return }
        }), for: .editingDidEnd)
        return datePicker
    }()
    
    lazy var wrapper = UIStackView()
    
    lazy var button = UIButton(primaryAction: .init(handler: { [weak self] _ in
        guard let self else { return }
        self.delegate?.dateChanged(date: datePicker.date)
        self.dismiss(animated: true)
    }))
    
    override func viewDidLoad() {
        view.addSubview(wrapper)
        wrapper.addSubview(datePicker)
        wrapper.backgroundColor = .white
        view.backgroundColor = .clear
        datePicker.date = delegate?.date() ?? .now
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Применить", for: .normal)
        button.titleLabel?.font = Fonts.headingText
        wrapper.spacing = 5
        wrapper.addArrangedSubview(datePicker)
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
