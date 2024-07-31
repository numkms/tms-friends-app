//
//  LoadingView.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 29.07.2024.
//

import UIKit

class LoadingView: UIView {
    
    private var circleLayer: CAShapeLayer = .init()
    var animationDuration: TimeInterval = 1.5
    
    private let animationKey: String = "loadingAnimation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle:  3 * .pi / 2 ,
            clockwise: true
        )
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        
        layer.addSublayer(circleLayer)
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.repeatCount = Float.infinity
        circleLayer.add(animation, forKey: animationKey)
    }
    
    func endAnimating() {
        circleLayer.removeAnimation(forKey: animationKey)
    }
}
