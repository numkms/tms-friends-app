//
//  PlusOneViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import UIKit


final class PlusOneModel {
    var currentValue: Int = 0
    
    init(initialValue: Int = 0) {
        currentValue = initialValue
    }
    
    func addValue(value: Int = 1) -> Int {
        currentValue += value
        return currentValue
    }
    
    func stringValue() -> String {
        return "\(currentValue)"
    }
}

protocol PlusOneViewDelegate: AnyObject {
    func plusButtonDidTap()
}

class PlusOneView: UIView {
    lazy var label: UILabel = .init()
    
    weak var delegate: PlusOneViewDelegate?
    
    lazy var button: UIButton = .init(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.delegate?.plusButtonDidTap()
    }))
    
    lazy var stack = UIStackView(arrangedSubviews: [label, button])
    
    // Programmaticly
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    // From storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        addSubview(stack)
        button.setTitle("+1", for: .normal)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func update(value: String) {
        label.text = value
    }
}

class PlusOneViewControllerMVC2: UIViewController, PlusOneViewDelegate {
    
    func plusButtonDidTap() {
        _ = model.addValue()
        contentView.update(value: model.stringValue())
    }
    
    lazy var model: PlusOneModel = .init()
    lazy var contentView = PlusOneView(frame: .zero)
    
    override func loadView() {
        view = contentView
        contentView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

class PlusOneViewControllerMVC: UIViewController {
    lazy var label: UILabel = .init()
    
    lazy var button: UIButton = .init(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.model.addValue()
        self?.label.text = self?.model.stringValue()
    }))
    
    lazy var stack = UIStackView(arrangedSubviews: [label, button])
    
    lazy var model: PlusOneModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        button.setTitle("+1", for: .normal)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


class PlusOneViewController: UIViewController {
    lazy var label: UILabel = .init()
    lazy var button: UIButton = .init(type: .system, primaryAction: .init(handler: { [weak self] _ in
        let currentValue = Int(self?.label.text ?? "") ?? 0
        self?.label.text = "\(currentValue + 1)"
    }))
    
    lazy var stack = UIStackView(arrangedSubviews: [label, button])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        button.setTitle("+1", for: .normal)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
