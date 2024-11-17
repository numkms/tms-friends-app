//
//  ViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import UIKit

class ViewController: UIViewController {
    
    let targetService: TargetService = .init(
        storage: TillFirebaseStorage()
    )
    
    lazy var tableView: UITableView = .init()
    
    let cellReuseIdentifier = "targetCell"
    
    @MainActor
    var targets: [Target] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func loadTargets() {
        Task {
            let targets = await targetService.storage.preparedTargets()
            Task { @MainActor in
                self.targets = targets
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: #selector(createTarget))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Войти", style: .done, target: self, action: #selector(login))
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.reloadData()
        
        loadTargets()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func createTarget() {
        CreateTargetRouter.shared.present(on: self)
//        vc.delegate = self
        
    }
    
    @objc func login() {
        let factory = AuthFactory(authService: AuthServiceFirebase())
        self.present(factory.build(), animated: true)
    }
}

extension ViewController: CreateTargetViewControllerDelegate {
    func didCreateTarget(name: String, date: Date, contact: Target.Contact?) {
        Task {
            _ = await targetService.createTarget(name: name, date: date, contact: contact)
            targets = await targetService.storage.preparedTargets()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            let selectedTarget = await targetService.storage.preparedTargets()[indexPath.row]
            Task { @MainActor in
                let viewController = TargetViewController(
                    target: selectedTarget,
                    storage: targetService.storage
                )
                viewController.modalPresentationStyle = .pageSheet
                viewController.sheetPresentationController?.detents = [.medium()]
                present(viewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = targets[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return  .init(actions: [.init(
            style: .destructive,
            title: "Удалить",
            handler: { [weak self] _, _, _ in
                guard let self else { return }
                Task { [weak self] in
                    self?.targetService.delete(target: await targetService.storage.preparedTargets()[indexPath.row])
                }
                
                tableView.reloadData()
            }
        )])
    }

}
