//
//  SecondViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit

class UserMenuViewController: UIViewController {
    
    struct Config {
        let customTitle: String
        let vcToShow: UIViewController
    }
    
    let config: Config
    
    lazy var menuListView = UIStackView()
    
    lazy var navigateButton: UIButton = .init(primaryAction: .init(handler: { _ in
        self.present(self.config.vcToShow, animated: true)
    }))
    
    func buildMenuItemView(
        icon: UIImage,
        title: String,
        action: UIAction
    ) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let iconView = UIImageView(image: icon)
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let actionView = UIButton(primaryAction: action)
        actionView.titleLabel?.widthAnchor.constraint(equalTo: actionView.widthAnchor).isActive = true
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.setTitle(title, for: .normal)
        actionView.configuration?.contentInsets = .zero
        
        let chevron = UIImageView(image: .init(UIImage(systemName: "chevron.right")!))
        chevron.widthAnchor.constraint(equalToConstant: 30).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(actionView)
        stackView.addArrangedSubview(chevron)
        
        return stackView
    }
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setViewControllers([self], animated: true)
        menuListView.axis = .vertical
        menuListView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(menuListView)
        
        menuListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        menuListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        menuListView.addArrangedSubview(buildMenuItemView(
            icon: .checkmark, title: "Профиль", action: .init(handler: { _ in
                print("Нажали на профиль")
            })))
        menuListView.addArrangedSubview(buildMenuItemView(
            icon: .add, title: "Сообщения", action: .init(handler: { _ in
                print("Нажали на сообщения")
            })))
        menuListView.addArrangedSubview(buildMenuItemView(
            icon: .add, title: "Перейдите в этот раздел для того чтобы получить скидку 100%", action: .init(handler: { _ in
                print("Нажали на рекламу")
            })))
        menuListView.addArrangedSubview(buildMenuItemView(
            icon: UIImage(systemName: "person")!, title: "Друзья", action: .init(handler: { _ in
                let friendsViewController = FriendsViewController()
                self.navigationController?.pushViewController(friendsViewController, animated: true)
            })))
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeScreen(_ sender: Any) {
        dismiss(animated: true)
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



///
///
/// Главный экран - лейбл и картинка 
/// Экран логина
/// Экран информации о пользователе
/// Ввести логин и пароль  -> Да/Нет -> Экран профиля/Выводим ошибку
