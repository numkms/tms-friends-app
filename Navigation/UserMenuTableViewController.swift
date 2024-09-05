//
//  UserMenuTableViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 10.07.2024.
//

import UIKit

class UserMenuTableViewController: UIViewController {
    lazy var tableView = UITableView()
    
    let friendsCellIdentifier = "friendsCell"
    
    func pushFriendViewController() {
        navigationController?.pushViewController(
            FriendTableViewController(friendUUID: FriendsStorage.myFriends.first!.id),
            animated: true
        )
    }
    
    lazy var menuItems: [MenuItem] = [
        .init(
            name: "Профиль",
            icon: UIImage(systemName: "person"),
            action: pushFriendViewController
        ),
        .init(
            name: "Сообщения",
            icon: UIImage(systemName: "envelope") ,
            action: {
                print("Модуль сообщения пока не реализован")
            }
        ),
        .init(
            
                name: "Друзья",
                icon: UIImage(systemName: "person.3.sequence.fill"),
                action: { [weak self] in
                    let friendsViewController = FriendsViewController()
                    friendsViewController.delegate = self
                    self?.navigationController?.pushViewController(friendsViewController, animated: true)
                }
        )
    ]
    
    struct MenuItem: InfoTableViewCellModel {
        var title: String { name }
        var image: UIImage? { icon }
        
        let name: String
        let icon: UIImage?
        let action: () -> Void
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: friendsCellIdentifier)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self

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
    deinit {
        print("User menu table view deinited")
    }
}

extension UserMenuTableViewController: FriendsViewControllerDelegate {
    func bottomButtonDidTap() {
        print("нажали на кнопку внизу")
    }
    
    func friendButtonDidTap(friendNumber: Int) {
        print("нажали на друга с индексом \(friendNumber)")
    }
    
    func friendScreenDidAppear() {
        print("экран друга показался")
    }
    
    
}

extension UserMenuTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuItems[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserMenuTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: friendsCellIdentifier
        ) as? InfoTableViewCell
        cell?.setup(model: menuItems[indexPath.row])
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }
}
