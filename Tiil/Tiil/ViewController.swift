//
//  ViewController.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import UIKit

class ViewController: UIViewController {
    
    let targetService: TargetService = .init(
        storage: RealmDataStorage()
    )
    
    lazy var tableView: UITableView = .init()
    
    var targets: [Target] {
        targetService.currentTargets
    }
    
    let cellReuseIdentifier = "targetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: #selector(createTarget))
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
        
        // Do any additional setup after loading the view.
    }
    
    @objc func createTarget() {
        let vc = CreateTargetViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension ViewController: CreateTargetViewControllerDelegate {
    func didCreateTarget(name: String, date: Date) {
        _ = targetService.createTarget(name: name, date: date)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTarget = targets[indexPath.row]
        let viewController = TargetViewController(
            target: selectedTarget,
            storage: targetService.storage
        )
        viewController.modalPresentationStyle = .pageSheet
        viewController.sheetPresentationController?.detents = [.medium()]
        present(viewController, animated: true)
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
                self.targetService.delete(target: targetService.currentTargets[indexPath.row])
                tableView.reloadData()
            }
        )])
    }

}
