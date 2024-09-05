//
//  ViewController.swift
//  Weather
//
//  Created by Vladimir Kurdiukov on 04.09.2024.
//

import UIKit

class ViewController: UIViewController {
    /// Массив сити
    /// Тейбл вью
    /// Ресурс
    ///
    var cities: [[String: Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView = UITableView()
    let reuseIdentifier = "cityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        loadCities()
        // Do any additional setup after loading the view.
    }
    
    func loadCities() {
        let thread = Thread { [weak self] in
            guard let filePath = Bundle.main.path(
                forResource: "cities",
                ofType: "json"
            ) else { return }
            let fileURL = URL(fileURLWithPath: filePath)
            guard let data = try? Data(contentsOf: fileURL) else { return }
            guard let citiesArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            DispatchQueue.main.async { 
                self?.cities = citiesArray
            }
        }
        thread.start()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let name = cities[indexPath.row]["name"] as? String,
              let established = cities[indexPath.row]["established"] as? Int else { return UITableViewCell() }
        cell.textLabel?.text = "\(name), since \(established)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}
