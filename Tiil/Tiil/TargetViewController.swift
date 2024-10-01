//
//  TargetViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import UIKit

class TargetViewController: UIViewController {
    let target: Target
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 30)
       return label
    }()
    
    lazy var progressLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 35)
        label.numberOfLines = 0
       return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var textField: UITextField = .init()
    
    lazy var addButton: UIButton = .init()
    
    let storage: TargetsStorage
    
    init(
        target: Target,
        storage: TargetsStorage
    ) {
        self.target = target
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func add() {
        guard let text = textField.text else { return }
        storage.addNote(
            note: .init(
                message: text,
                createdAt: .now
            ),
            to: target
        )
        textField.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = target.name
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        addButton.setTitle("Добавить заметку", for: .normal)
        addButton.backgroundColor = .blue
        textField.placeholder = "Введите заметку"
        view.addSubview(stackView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(progressLabel)
        target.notes.forEach { note in
            let label = UILabel()
            label.text = note.message
            stackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(addButton)
        
        Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true) { [weak self] _ in
                self?.updateTargetTillDate()
            }
        updateTargetTillDate()
    }
    
    
    func updateTargetTillDate() {
        let dateComponents = Calendar.current.dateComponents([.day, .minute, .hour, .second, .month], from: .now, to: target.date)
        guard
            let day = dateComponents.day,
            let month = dateComponents.month,
            let hour = dateComponents.hour,
            let minute = dateComponents.minute,
            let secound = dateComponents.second
        else { return }
        progressLabel.text = "Осталось \(month) месяцев \(day) дней  \(hour) часов \(minute) минут \(secound) секунд "
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
