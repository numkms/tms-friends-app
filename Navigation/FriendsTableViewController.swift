//
//  FriendsTableViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 10.07.2024.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    
    let stackView = UIStackView()
    let iconView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        iconView.image = nil
    }
    
    private func setupCell() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(nameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: InfoTableViewCellModel) {
        nameLabel.text = model.title
        iconView.image = model.image
    }
}

protocol InfoTableViewCellModel {
    var title: String { get }
    var image: UIImage? { get }
}

class FriendsTableViewController: UIViewController {
    
    lazy var tableView = UITableView()
    
    let friendsCellIdentifier = "friendsCell"
    
    var myFriends: [FriendViewController.Friend] = [
        .init(name: "Влад", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Наталья", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Николай", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Вячеслав", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Владимир", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Максим", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Олег", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Евгений", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Алексей", age: 45, avatar: UIImage(systemName: "eraser")),
    ]
    
    var friendsRequests: [FriendViewController.Friend] = [
        .init(name: "Анна", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Наталья", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Юлия", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Яна", age: 20, avatar: UIImage(systemName: "person")),
    ]
    
    lazy var sections: [FriendsTableSection] = [
        .init(name: "Мои друзья", friends: myFriends),
        .init(name: "Запросы в друзья", friends: friendsRequests)
    ]
    
    struct FriendsTableSection {
        let name: String
        let friends: [FriendViewController.Friend]
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
    
    var cache: [IndexPath: CGFloat] = [:]

}

extension FriendsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = FriendViewController(
            friend: sections[indexPath.section].friends[indexPath.row]
        )
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FriendsTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].friends.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: friendsCellIdentifier
        ) as? InfoTableViewCell
        cell?.setup(model: sections[indexPath.section].friends[indexPath.row])
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }
}

