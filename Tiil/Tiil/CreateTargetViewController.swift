//
//  CreateTargetViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import UIKit

protocol CreateTargetViewControllerDelegate: AnyObject {
    func didCreateTarget(name: String, date: Date)
}

class CreateTargetViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.text = "Создать цель"
       label.font = .systemFont(ofSize: 30)
       return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название цели"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var saveButton: UIButton = {
       let button = UIButton(primaryAction: .init(handler: { _ in
           guard let text = self.nameTextField.text, !text.isEmpty else { return }
           self.delegate?.didCreateTarget(name: text, date: self.datePicker.date)
           self.dismiss(animated: true)
       }))
       button.setTitle("Сохранить", for
                       : .normal)
       button.setTitleColor(.black, for: .normal)
       return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = .now
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var delegate: CreateTargetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(16, after: titleLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
