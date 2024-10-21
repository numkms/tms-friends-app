//
//  DeeplinksHandler.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 21.10.2024.
//

import UIKit

class DeeplinksHandler {
    /// com.till://till/create -> CreateTarget
    static let defaultScheme = "com.till://"
    
    private var registredRoutes: [URL: () -> UIViewController] = [:]
    
    // Служит для отображения результата диплинка
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    // Обрабатывает диплинк в момент открытия приложения или ссылки из Safari
    func process(url: URL) {
        guard let factory = registredRoutes[url] else { return }
        rootViewController.present(factory(), animated: true)
    }
    
    // Добавляет диплинк в хранилище диплинков для послед обработки
    func register(_ factory: @escaping () -> UIViewController, for url: URL?) {
        guard let url else { return }
        registredRoutes[url] = factory
    }
}
