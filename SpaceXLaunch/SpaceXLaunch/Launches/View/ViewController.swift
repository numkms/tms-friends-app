//
//  ViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import UIKit
import Combine


class LaunchesViewController: UIViewController {
    lazy var launchesView: LaunchesView = .init { [weak self] launchId in
        self?.present(LaunchViewController(viewModel: .init(), launchID: launchId), animated: true)
    }
    
    let viewModel: LaunchesViewModel
    
    init(viewModel: LaunchesViewModel) {
        self.viewModel = viewModel
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
        viewModel.launches.bind { [weak self] launches in
            guard let launches else { return }
            self?.launchesView.launches = launches
        }
        viewModel.loadLaunch()
    }
}

class CombineViewController: UIViewController {
    lazy var launchesView: LaunchesView = .init { [weak self] launchId in
        self?.present(LaunchViewController(viewModel: .init(), launchID: launchId), animated: true)
    }
    
    let viewModel: CombineLaunchViewModel
    
    var cancellable: [AnyCancellable] = []
    
    init(viewModel: CombineLaunchViewModel) {
        self.viewModel = viewModel
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
        viewModel.launches.sink { error in
            print(error)
        } receiveValue: { [weak self] launches in
            self?.launchesView.launches = launches
        }.store(in: &cancellable)
        viewModel.loadLaunch()
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
}

class ViewController: UIViewController {
    let presenter: LaunchPresenter
    
    lazy var launchesView: LaunchesView = .init { [weak self] launchId in
        self?.present(LaunchViewController(viewModel: .init(), launchID: launchId), animated: true)
    }
    
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
    lazy var titleLabel = UILabel()
    lazy var tableView = UITableView()
    
    let reuseIdentifier = "launch"
    
    var launches: [ViewModels.Launch] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let openLaunch: (Int) -> Void
    
    init(openLaunch: @escaping (Int) -> Void) {
        self.openLaunch = openLaunch
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = NSLocalizedString(
            "Welcome to launches page",
            comment: "Header of list of launches"
        )
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        let translatedString = NSLocalizedString("You have watched launches", comment: "Footer of list of launches")
        label.text = String.localizedStringWithFormat(translatedString, String(launches.count), "10")
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? LaunchTableViewCell
        cell?.configure(model: launches[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openLaunch(launches[indexPath.row].id)
    }
}



