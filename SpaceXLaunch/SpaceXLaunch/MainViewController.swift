//
//  MainViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        present(GyroscopeViewController(), animated: true)
//        present(AccelerometerViewController(), animated: true)
        present(buildMVVMCombineModule(), animated: true)
    }
    
    func buildVIPModule() -> UIViewController {
        let presenter = LaunchPresenter()
        let interactor = LaunchInteractor(
            client: URLSession.shared,
            decoder: JSONDecoder(),
            presenter: presenter
        )
        let viewController = ViewController(presenter: presenter)
        presenter.interactor = interactor
        presenter.view = viewController
        return viewController
    }
    
    func buildMVVMModule() -> UIViewController {
        let viewModel = LaunchesViewModel()
        return LaunchesViewController(viewModel: viewModel)
    }
    
    func buildMVVMCombineModule() -> UIViewController {
        let viewModel = CombineLaunchViewModel(
            client: URLSession.shared,
            decoder: JSONDecoder()
        )
        return CombineViewController(viewModel: viewModel)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
