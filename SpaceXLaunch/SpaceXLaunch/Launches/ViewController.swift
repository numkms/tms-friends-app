//
//  ViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import UIKit


class ViewController: UIViewController {
    let presenter: LaunchPresenter
    
    lazy var launchesView: LaunchesView = .init()
    
    init(presenter: LaunchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = launchesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadData()
    }
    
    func configure(with launches: [ViewModels.Launch]) {
        launchesView.launches = launches
    }
}

class LaunchesView: UIView {
    lazy var tableView = UITableView()
    
    let reuseIdentifier = "launch"
    
    var launches: [ViewModels.Launch] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .init(
            top: 16,
            left: .zero,
            bottom: 16,
            right: .zero
        )
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LaunchesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? LaunchTableViewCell
        cell?.configure(model: launches[indexPath.row])
        return cell ?? UITableViewCell()
    }
}



