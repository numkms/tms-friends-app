//
//  CombineViewModel.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 14.10.2024.
//

import Combine
import Foundation

class CombineLaunchViewModel {
    
    enum LaunchError: Swift.Error {
        case decodingError
        case serverError(Error)
    }
    
    let client: URLSession
    let decoder: JSONDecoder
    
    init(
        client: URLSession,
        decoder: JSONDecoder
    ) {
        self.client = client
        self.decoder = decoder
    }
    
    var launchesStored: CurrentValueSubject<[ViewModels.Launch], Never> = .init([])
    var launches: PassthroughSubject<[ViewModels.Launch], Error> = .init()
    
    private let launchesURL = URL(string: "https://api.spacexdata.com/v3/launches")
    
    func loadLaunch() {
        guard let url = launchesURL else { return }
        let request = URLRequest(url: url)
        let task = client.dataTask(with: request) { [weak self] data, response, error in
            guard let data else { return }
            guard let launches = try? self?.decoder.decode([Models.Launch].self, from: data) else { return }
            DispatchQueue.main.async {
                self?.launches.send(launches.map { launchModel in
                    return ViewModels.Launch(
                        id: launchModel.flightNumber ?? 0,
                        title: launchModel.missionName ?? "NO NAME",
                        subtitle: launchModel.launchDateUTC ?? "UNKNOWN DATE",
                        icon: launchModel.launchSuccess == true ? .checkmark : .remove
                    )
                })
                
            }
        }
        task.resume()
    }
}
