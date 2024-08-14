//
//  GuestViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit

class GuestViewController: UIViewController {
    enum Constants {
        static var padding: CGFloat = 10
        static var radius: CGFloat = 20
    }
    
    lazy var backgroundImageView = UIImageView()
    lazy var imageView = UIImageView()
    lazy var label = UIButton(configuration: .plain(), primaryAction: UIAction(handler: { _ in
        let rootViewController = FriendsViewController(
            onFriendClick: nil,
            bottomButtonConfig: .init(title: "Ничего не делает", action: {})
        )
        let navigationViewController = UINavigationController(
            rootViewController: rootViewController
        )
        self.present(navigationViewController, animated: true)
    }))
    lazy var wrapper = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Add background
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        backgroundImageView.image = .init(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
    
        // MARK: - Set data
        label.setTitle("Welcome to the club, buddy!", for: .normal)
        label.setTitleColor(.white, for: .normal)
        imageView.image = .checkmark
        // MARK: - Configuring views
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.textColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .black.withAlphaComponent(0.3)
        wrapper.layer.cornerRadius = Constants.radius
        // MARK: - Add subviews
        view.addSubview(wrapper)
        wrapper.addSubview(imageView)
        wrapper.addSubview(label)
        
        // MARK: - Wrapper constraints
        wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // MARK: - Image view constraints
        imageView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: Constants.padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: Constants.padding).isActive  = true
        imageView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -Constants.padding).isActive  = true
        
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // MARK: - Label constraints
        label.topAnchor.constraint(
            equalTo: imageView.bottomAnchor,
            constant: Constants.padding
        ).isActive = true
        label.leadingAnchor.constraint(
            equalTo: wrapper.leadingAnchor,
            constant: Constants.padding
        ).isActive = true
        label.trailingAnchor.constraint(
            equalTo: wrapper.trailingAnchor, 
            constant: -Constants.padding
        ).isActive = true
        label.bottomAnchor.constraint(
            equalTo: wrapper.bottomAnchor,
            constant: -Constants.padding
        ).isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidLogin),
            name: NSNotification.Name("userDidLogin"),
            object: nil
        )
    
    }
    
    @objc func userDidLogin(_ notification: Notification) {
        print(notification.userInfo)
        guard let userName = notification.userInfo?["userName"] as? String else { return }
        label.setTitle("You are part of the club, \(userName)!", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        present(CollectionViewController(), animated: true)
        let uservc = UINavigationController(rootViewController: UserMenuTableViewController())
        
        addChild(uservc)
        view.addSubview(uservc.view)
        
        uservc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uservc.view.topAnchor.constraint(equalTo: view.topAnchor),
            uservc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uservc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uservc.view.heightAnchor.constraint(equalToConstant: 300),
        ])
        uservc.didMove(toParent: self)
        
//        uservc.willMove(toParent: nil)
//        uservc.view.removeFromSuperview()
//        uservc.removeFromParent()
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
