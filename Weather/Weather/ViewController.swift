//
//  ViewController.swift
//  Weather
//
//  Created by Vladimir Kurdiukov on 04.09.2024.
//

import UIKit

class Counter {
    var count: Int = 0
    
    private let queue = DispatchQueue(label: "com.myclass.queue", qos: .userInteractive)
    
    func increment() {
        queue.sync {
//            print("before: ", count)
        }
        
        queue.sync {
//            print("queue", count)
            count += 1
        }
        
        queue.sync {
            print("after: ", count)
        }
    }
    
    func getCount() -> Int {
        return queue.sync { [weak self] in
            guard let self else {
                print("0")
                return 0
            }
            return self.count
        }
    }
}

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
//        let queue = DispatchQueue(label: "default")
//        print("Считаем")
//        let item = DispatchWorkItem {
//            sleep(5)
//        }
//        item.notify(queue: .main) {
//            print("Досчитали")
//        }
//        queue.async(execute: item)
////        queue.sync {
////            sleep(5)
////            DispatchQueue.main.async {
////                print("Досчитали")
////            }
////        }
        Task {
            await loadCities()
            let date = Calendar.current.date(byAdding: .init(timeZone: TimeZone(identifier: "Moscow/Russia")), to: .now)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @MainActor
    func presentCities(cities: [[String: Any]]) {
        self.cities = cities
    }
        
    func loadCities() async {
        guard let filePath = Bundle.main.path(
            forResource: "cities",
            ofType: "json"
        ) else { return }
        let fileURL = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let citiesArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
        presentCities(cities: citiesArray)
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
