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
        
    lazy var loadingView: LoadingView = LoadingView(frame: .init(
        x: contentView.center.x - 20,
        y: contentView.center.y - 20,
        width: 40,
        height: 40
    ))
    
    
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
        addSubview(loadingView)
        loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.readyLayout()
            self.loadingView.endAnimating()
            self.loadingView.isHidden = true
        }
    }
    
    func readyLayout() {
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

    var myFriends: [FriendViewController.Friend] {
        FriendsStorage.myFriends
    }
    
    var friendsRequests: [FriendViewController.Friend] {
        FriendsStorage.friendsRequests
    }
    
    var sections: [FriendsTableSection] {
        [
            .init(name: "Мои друзья", friends: myFriends),
            .init(name: "Запросы в друзья", friends: friendsRequests)
        ]
    }
    
    struct FriendsTableSection {
        let name: String
        let friends: [FriendViewController.Friend]
    }
    
    lazy var loadingView: LoadingView = LoadingView(frame: .init(
        x: view.center.x - 50,
        y: view.center.y - 50,
        width: 100,
        height: 100
    ))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(loadingView)
        loadingView.animationDuration = 1
        loadingView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupView()
            self.loadingView.endAnimating()
            self.loadingView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func setupView() {
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
        let viewController = FriendTableViewController(
            friendUUID: sections[indexPath.section].friends[indexPath.row].id
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

