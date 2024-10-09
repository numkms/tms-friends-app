//
//  LaunchInteractor.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import Foundation

class LaunchInteractor {
    let client: URLSession
    let decoder: JSONDecoder
    let presenter: LaunchPresenter
    
    init(
        client: URLSession,
        decoder: JSONDecoder,
        presenter: LaunchPresenter
    ) {
        self.client = client
        self.decoder = decoder
        self.presenter = presenter
    }
    
    private let launchesURL = URL(string: "https://api.spacexdata.com/v3/launches")
    
    func loadLaunches() {
        guard let url = launchesURL else { return }
        let request = URLRequest(url: url)
        let task = client.dataTask(with: request) { [weak self] data, response, error in
            guard let data else { return }
            guard let launches = try? self?.decoder.decode([Models.Launch].self, from: data) else { return }
            self?.presenter.launchesDidLoad(models: launches)
        }
        task.resume()
    }
}
