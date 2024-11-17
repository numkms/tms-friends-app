//
//  LaunchViewModel.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import Foundation

class LaunchesViewModel {
    var launches: Bindable<[ViewModels.Launch]> = .init()
    
    func loadLaunch() {
        API.shared.loadLaunch { [weak self] result in
            switch result {
            case let .success(launches):
                self?.launches.value = launches.map { launchModel in
                    return ViewModels.Launch(
                        id: launchModel.flightNumber ?? 0,
                        title: launchModel.missionName ?? "NO NAME",
                        subtitle: launchModel.launchDateUTC ?? "UNKNOWN DATE",
                        icon: launchModel.launchSuccess == true ? .checkmark : .remove
                    )
                }
            case .failure:
                self?.launches.value = []
            }
        }
    }
}
