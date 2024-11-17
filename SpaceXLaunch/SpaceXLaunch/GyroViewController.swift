//
//  GyroViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 06.11.2024.
//

import Foundation
import UIKit
import CoreMotion

class GyroscopeViewController: UIViewController {
    
    private let motionManager = CMMotionManager()
    private let circleView = UIView() // Круг, который будет двигаться
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startGyroscopeUpdates()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Настраиваем круг
        circleView.frame = CGRect(x: view.bounds.midX - 25, y: view.bounds.midY - 25, width: 50, height: 50)
        circleView.layer.cornerRadius = 25
        circleView.backgroundColor = .systemBlue
        view.addSubview(circleView)
    }
    
    private func startGyroscopeUpdates() {
        guard motionManager.isGyroAvailable else { return }
        
        motionManager.gyroUpdateInterval = 0.02 // Интервал обновления гироскопа
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            
            // Получаем данные гироскопа по осям
            let rotationRateX = CGFloat(data.rotationRate.x)
            let rotationRateY = CGFloat(data.rotationRate.y)
            let rotationRateZ = CGFloat(data.rotationRate.z)
            
            // Обновляем положение круга
            var newCenter = self.circleView.center
            newCenter.x += rotationRateY * 10 // Масштабируем для большей чувствительности
            newCenter.y += rotationRateX * 10
            self.circleView.frame.size = .init(
                width: self.circleView.frame.size.width + (rotationRateZ * 10),
                height: self.circleView.frame.size.height + (rotationRateZ * 10)
            )
            
            // Ограничиваем круг в пределах экрана
            newCenter.x = min(max(newCenter.x, 25), self.view.bounds.width - 25)
            newCenter.y = min(max(newCenter.y, 25), self.view.bounds.height - 25)
            
            self.circleView.center = newCenter
        }
    }
    
    deinit {
        motionManager.stopGyroUpdates()
    }
}
