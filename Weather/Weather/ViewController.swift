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
    var citiesOld: [[String: Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cities: [City] = [] {
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
        loadUsers()
        Task {
            await loadCitiesCodable()
            let date = Calendar.current.date(byAdding: .init(timeZone: TimeZone(identifier: "Moscow/Russia")), to: .now)
            
        }
        citiesToJson()
        // Do any additional setup after loading the view.
    }
    
    @MainActor
    func oldPresentCities(cities: [[String: Any]]) {
        self.citiesOld = cities
    }
    
    @MainActor
    func presentCities(cities: [City]) {
        self.cities = cities
    }
    
    func loadCitiesCodable() async {
        guard let data = readFile() else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let cities = try! decoder.decode([City].self, from: data)
        presentCities(cities: cities)
    }
    
    func readFile() -> Data? {
        guard let filePath = Bundle.main.path(
            forResource: "cities",
            ofType: "json"
        ) else { return nil }
        let fileURL = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return data
    }
        
    func loadCities() async {
        guard let data = readFile() else { return }
        guard let citiesArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
        oldPresentCities(cities: citiesArray)
    }
    
    func citiesToJson() {
        let cities: [City] = [
            City(name: "Kishinev", area: 12323, population: 850000, growthIndex: 2.3),
            City(name: "Minsk", area: 222323, population: 2000000, growthIndex: 2.4),
            City(name: "Moscow", area: 1233332, population: 17000000, growthIndex: 2.5),
            City(name: "Nicosia", established: 1974, area: 123321, population: 200000, growthIndex: 1.3, peopleKnowledgeIndex: 1000, dateOfLastRevolution: .now)
        ]
        let encoder = JSONEncoder()
        guard let result = try? encoder.encode(cities) else { return }
        print(String(data: result, encoding: .utf8))
    }
    
    func loadUsers() {
        let network = Network()
        network.loadUsers { users in
            DispatchQueue.main.async {
                print(users)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func makeOldCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let name = citiesOld[indexPath.row]["name"] as? String,
              let established = citiesOld[indexPath.row]["established"] as? Int else { return UITableViewCell() }
        cell.textLabel?.text = "\(name), since \(established)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = "\(city.name), since \(city.establishedStr), \(city.peopleKnowledgeIndex) \(city.dateOfLastRevolution) \(city.growthIndex) \(city.population)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}
