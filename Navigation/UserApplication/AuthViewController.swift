//
//  AuthViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit

class AuthViewController: UIViewController {
    enum Constants {
        static var padding: CGFloat = 10
        static var radius: CGFloat = 20
    }
    
    
    lazy var imageView = UIImageView()
    
    lazy var userNamelabel = UILabel()
    lazy var passwordLabel = UILabel()
    
    lazy var userNameField = UITextField()
    lazy var passwordField = UITextField()
    
    lazy var statusLabel = UILabel()
    
    lazy var loginButton = UIButton()
    lazy var forgetPasswordButton = UIButton()
    
    lazy var wrapper = UIStackView()
    
    lazy var buttonsStack = UIStackView()
    
    func setupUI() {
        imageView.image = .init(systemName: "person.crop.circle.fill")
        userNamelabel.text = "Username"
        passwordLabel.text = "Password"
        userNameField.placeholder = "Enter your username"
        passwordField.placeholder = "Enter your password"
        loginButton.setTitle("Login", for: .normal)
        forgetPasswordButton.setTitle("Reset password?", for: .normal)
        loginButton.setTitleColor(.blue, for: .normal)
        forgetPasswordButton.setTitleColor(.red, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.addSubview(wrapper)
        
        // MARK: - Configuring views
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .black.withAlphaComponent(0.1)
        wrapper.layer.cornerRadius = Constants.radius
        
        wrapper.axis = .vertical
        wrapper.alignment = .center
        
        wrapper.distribution = .fill
        
        buttonsStack.axis = .horizontal
        
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        
        // MARK: - Wrapper Stack layout
        
        wrapper.addArrangedSubview(imageView)
        wrapper.addArrangedSubview(userNamelabel)
        wrapper.addArrangedSubview(userNameField)
        wrapper.addArrangedSubview(passwordLabel)
        wrapper.addArrangedSubview(passwordField)
        wrapper.addArrangedSubview(statusLabel)
        wrapper.addArrangedSubview(buttonsStack)
        wrapper.addArrangedSubview(UIView())
        
        wrapper.setCustomSpacing(20, after: buttonsStack)
        wrapper.setCustomSpacing(20, after: userNameField)
        wrapper.setCustomSpacing(20, after: passwordField)

        // MARK: - Buttons stack layout
        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(forgetPasswordButton)
        buttonsStack.spacing = 30
        buttonsStack.distribution = .fillEqually
        // MARK: - Wrapper position layout
        wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        wrapper.heightAnchor.constraint(equalToConstant: 410).isActive = true
        
        addActions()
    }
    
    
    func addActions() {
        loginButton.addAction(UIAction.init(handler: { _ in
            self.login()
        }), for: .touchUpInside)
    }
    
    func login() {
        let login = userNameField.text
        let password = passwordField.text
        
        if let login = validate(login ?? "", password ?? "") {
            let viewController = UserMenuViewController(
                config: .init(
                    customTitle: login,
                    vcToShow: UIViewController()
                ))
            clear()
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            clear()
            statusLabel.text = "Не правильный логин или пароль"
        }
    }

    func clear() {
        statusLabel.text = nil
        userNameField.text = nil
        passwordField.text = nil
    }
    
    func validate(_ login: String, _ password: String) -> String?  {
        return ""
        let users: [String: String] = [
            "nikolay@mail.ru": "qwergunsn",
            "vladimir@gmail.com": "123566",
            "nikita@yahoo.com": "JKDIwqi1dnni1@22n##",
            "1": "1",
        ]
        
        guard 
            let userPassword = users[login],
            password == userPassword
        else { return nil }
        return login
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
