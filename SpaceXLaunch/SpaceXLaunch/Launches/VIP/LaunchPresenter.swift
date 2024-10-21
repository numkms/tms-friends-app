//
//  LaunchPresenter.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import Foundation

class LaunchPresenter {
    var interactor: LaunchInteractor?
    weak var view: ViewController?
    
    func loadData() {
        interactor?.loadLaunches()
    }
    
    func launchesDidLoad(models: [Models.Launch]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.configure(with: models.map { launchModel in
                return ViewModels.Launch(
                    id: launchModel.flightNumber ?? 0,
                    title: launchModel.missionName ?? "NO NAME",
                    subtitle: launchModel.launchDateUTC ?? "UNKNOWN DATE",
                    icon: launchModel.launchSuccess == true ? .checkmark : .remove
                )
            })
        }
    }
    
    func launchesDidError() {
        
    }
}
