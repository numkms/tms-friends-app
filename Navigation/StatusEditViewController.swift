//
//  StatusEditViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 08.07.2024.
//

import UIKit


protocol StatusEditViewControllerDelegate: AnyObject {
    func statusDidSaved(newStatus: String)
}

class StatusEditViewController: UIViewController {
    lazy var field = UITextField()
    lazy var saveButton = UIButton(primaryAction: .init(handler: { _ in
        self.save()
    }))
    
    weak var delegate: StatusEditViewControllerDelegate?
    
    let status: String?
    let onSave: (String) -> Void
    
    init(
        status: String?,
        onSave: @escaping (String) -> Void
    ) {
        self.status = status
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func save() {
        delegate?.statusDidSaved(newStatus: field.text ?? "")
        onSave(field.text ?? "")
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(field)
        view.addSubview(saveButton)
        saveButton.setTitle("Сохранить", for: .normal)
        field.text = status
        field.placeholder = "Введите ваш статус"
        field.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: view.topAnchor),
            field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            saveButton.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
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
