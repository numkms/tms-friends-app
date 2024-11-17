//
//  AccViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 06.11.2024.
//

import UIKit
import CoreMotion

class AccelerometerViewController: UIViewController {
    
    private let motionManager = CMMotionManager()
    private let circleView = UIView() // Круг, который будет двигаться
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAccelerometerUpdates()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Настраиваем круг
        circleView.frame = CGRect(x: view.bounds.midX - 25, y: view.bounds.midY - 25, width: 50, height: 50)
        circleView.layer.cornerRadius = 25
        circleView.backgroundColor = .systemGreen
        view.addSubview(circleView)
    }
    
    private func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.000001 // Интервал обновления данных акселерометра
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            
            // Получаем данные ускорения по осям
            let accelerationX = CGFloat(data.acceleration.x)
            let accelerationY = CGFloat(data.acceleration.y)
            let accelerationZ = CGFloat(data.acceleration.z)
            
            // Обновляем положение круга
            var newCenter = self.circleView.center
            let speed: CGFloat = 100
            
            newCenter.x += accelerationX * speed // Масштабируем для большей чувствительности
            newCenter.y -= accelerationY * speed
            
            print("width", self.circleView.frame.size.width + (accelerationZ * 100))
            print("height",self.circleView.frame.size.height + (accelerationZ * 100))
            print("center", newCenter)
            
            self.circleView.frame.size = .init(
                width: self.circleView.frame.size.width + (accelerationZ * 100),
                height: self.circleView.frame.size.height + (accelerationZ * 100)
            )
            self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
//            print(self.circleView.frame.size / 2)
            
            // Ограничиваем круг в пределах экрана
            newCenter.x = min(max(newCenter.x, 25), self.view.bounds.width - 25)
            newCenter.y = min(max(newCenter.y, 25), self.view.bounds.height - 25)
            
            self.circleView.center = newCenter
        }
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
