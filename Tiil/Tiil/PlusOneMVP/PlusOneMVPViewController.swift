//
//  PlusOneMVPViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 07.10.2024.
//

import UIKit

class PlusOneMVPViewController: UIViewController {
    
    lazy var label: UILabel = .init()
    
    lazy var button: UIButton = .init(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.presenter?.plusDidTap()
    }))
    
    lazy var stack = UIStackView(arrangedSubviews: [label, button])
    
    var presenter: PlusOneMVPPresenter?
    
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
    
    func updated(value: String) {
        label.text = value
    }

}
