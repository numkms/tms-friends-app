//
//  ViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var button: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        self?.performSegue(withIdentifier: "secondScreenRoute", sender: nil)
    }))
    lazy var buttonRed: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        self?.performSegue(withIdentifier: "redScreenRoute", sender: nil)
    }))
    lazy var buttonViolet: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        self?.performSegue(withIdentifier: "violetScreenRoute", sender: nil)
    }))
    
    lazy var goLoginButton: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        let storyboard = UIStoryboard(
            name: "LoginFlowStoryboard",
            bundle: nil
        )
        let viewController = storyboard.instantiateViewController(withIdentifier: "startViewController")
        self?.present(viewController, animated: true)
    }))
    
    lazy var goSecondViewControllerButton: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        let vcToShow = UIViewController()
        vcToShow.view.backgroundColor = .red
        let viewController = UserMenuViewController(
            config: .init(
                customTitle: "Второй контроллер",
                vcToShow: vcToShow
            )
        )
        self?.present(viewController, animated: true)
    }))
    
    lazy var goSecondViewControllerWithEnglishTitleButton: UIButton = .init(primaryAction: .init(handler: { [weak self] _ in
        let vcToShow = UIViewController()
        vcToShow.view.backgroundColor = .blue
        let viewController = UserMenuViewController(
            config: .init(
                customTitle: "Second view controller",
                vcToShow: vcToShow
            )
        )
        self?.present(viewController, animated: true)
    }))
    
    
    
    
    
    
    override func viewDidLoad() {
        let stack = UIStackView(arrangedSubviews: [
            button,
            buttonRed,
            buttonViolet,
            goLoginButton,
            goSecondViewControllerButton,
            goSecondViewControllerWithEnglishTitleButton
        ])
        stack.alignment = .top
        stack.distribution = .fillEqually
        stack.axis = .vertical
        view.addSubview(stack)
        goSecondViewControllerButton.setTitle("Go second controller by init", for: .normal)
        button.setTitle("Go on second screen", for: .normal)
        goSecondViewControllerWithEnglishTitleButton.setTitle("Go on secon screen english", for: .normal)
        buttonViolet.setTitle("Go on violet screen", for: .normal)
        buttonRed.setTitle("Go on red screen", for: .normal)
        goLoginButton.setTitle("Go login screen", for: .normal)
        stack.frame = .init(x: .zero, y: 200, width: 200, height: 300)
        super.viewDidLoad()
        
    }
}

