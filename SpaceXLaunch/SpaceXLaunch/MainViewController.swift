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
        let presenter = LaunchPresenter()
        let interactor = LaunchInteractor(
            client: URLSession.shared,
            decoder: JSONDecoder(),
            presenter: presenter
        )
        presenter.interactor = interactor
        let viewController = ViewController(presenter: presenter)
        presenter.view = viewController
        
        present(viewController, animated: true)
        
        
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
