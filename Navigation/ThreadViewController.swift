//
//  ThreadViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 04.09.2024.
//

import UIKit

class ThreadViewController: UIViewController {
    
    lazy var button: UIButton = .init()
    lazy var colorfullButton: UIButton = .init()
    lazy var label: UILabel = .init()
    lazy var stackView: UIStackView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        label.text = "Тут будет результат"
        label.textColor = .red

        button.setTitle("Посчитать", for: .normal)
        button.addTarget(self, action: #selector(count), for: .touchUpInside)
        button.setTitleColor(.red, for: .normal)
        
        colorfullButton.setTitle("Нажми меня", for: .normal)
        colorfullButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        colorfullButton.setTitleColor(.blue, for: .normal)
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(colorfullButton)
        stackView.addArrangedSubview(label)
        stackView.axis = .vertical
        
        // Do any additional setup after loading the view.
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func changeColor() {
        colorfullButton.setTitleColor([.red, .blue, .green].randomElement(), for: .normal)
    }
    
    @objc func count() {
        let array = Array(repeating: 2.0, count: 99999999)
        label.text = "Считаем..."
        var result: Double = 0
        
        let thread = Thread { [weak self] in
            result = array.reduce(1.0) { partialResult, value in
                return partialResult + 1.1
            }
            
            DispatchQueue.main.async {
                self?.label.text = "Результат \(result)"
            }
        }
        thread.qualityOfService = .userInitiated
        thread.start()
        
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
