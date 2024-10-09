//
//  LaunchViewModel.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import Foundation

class LaunchViewModel {
    let client: URLSession
    let decoder: JSONDecoder
    
    init(
        client: URLSession,
        decoder: JSONDecoder
    ) {
        self.client = client
        self.decoder = decoder
    }
    
    var launches: Bindable<[ViewModels.Launch]> = .init()
    
    private let launchesURL = URL(string: "https://api.spacexdata.com/v3/launches")
    
    func loadLaunch() {
        guard let url = launchesURL else { return }
        let request = URLRequest(url: url)
        let task = client.dataTask(with: request) { [weak self] data, response, error in
            guard let data else { return }
            guard let launches = try? self?.decoder.decode([Models.Launch].self, from: data) else { return }
            DispatchQueue.main.async {
                self?.launches.value = launches.map { launchModel in
                    return ViewModels.Launch(
                        title: launchModel.missionName ?? "NO NAME",
                        subtitle: launchModel.launchDateUTC ?? "UNKNOWN DATE",
                        icon: launchModel.launchSuccess == true ? .checkmark : .remove
                    )
                }
            }
        }
        task.resume()
    }
    
    
}
