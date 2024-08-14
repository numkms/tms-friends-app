//
//  AnimationsViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 05.08.2024.
//

import UIKit

class AnimationsViewController: UIViewController {
    
    lazy var squareView: UIView = .init()
    lazy var imageView: UIImageView = .init()
    lazy var constraintView: UIView = .init()
    
    
    var heightConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(constraintView)
        constraintView.translatesAutoresizingMaskIntoConstraints = false
        constraintView.backgroundColor = .darkGray
        
        heightConstraint = constraintView.heightAnchor.constraint(equalToConstant: 100)
        topConstraint = constraintView.topAnchor.constraint(equalTo: view.topAnchor)
        NSLayoutConstraint.activate([
            topConstraint!,
            constraintView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            constraintView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint!
        ])
        
        view.backgroundColor = .white
        squareView.frame = .init(
            x: view.bounds.width / 2 - 50,
            y: view.bounds.height / 2 - 50,
            width: 100,
            height: 100
        )
        squareView.backgroundColor = .red
        view.addSubview(squareView)
        view.addSubview(imageView)
        
        imageView.frame = .init(
            x: .zero,
            y: 70,
            width: 50,
            height: 50
        )
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = UIImage(systemName: "seal")
        
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        squareView.addGestureRecognizer(tapGestureRecognizer)
        
        let constraintGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContraint))
        constraintView.addGestureRecognizer(constraintGestureRecognizer)
    
        
        // Do any additional setup after loading the view.
    }
    
    let octagonImage = UIImage(systemName: "octagon")?.cgImage
    
    @objc func didTapCA() {
        let animation = CATransition()
        animation.type = .push
        animation.duration = 2
        imageView.layer.add(animation, forKey: "transition")
        imageView.layer.contents = octagonImage
    }
    
    @objc func didTapContraint() {
        topConstraint?.constant = topConstraint?.constant == 0 ? 100 : 0
        heightConstraint?.constant = heightConstraint?.constant == 200 ? 100 : 200
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            guard let view = self?.view else { return }
            self?.view.layoutIfNeeded()
            self!.squareView.layer.transform = CATransform3DMakeRotation(-0.5, 1, 0, 0)

        }
    
    }
    
    @objc func didTap() {
        // CABASICANIMATION1
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = squareView.layer.position
        animation.toValue = CGPoint.zero
        animation.duration = 2
        squareView.layer.add(animation, forKey: "positionAnimation")
        // CABASICANIMATION2
        let animationframe = CABasicAnimation(keyPath: "backgroundColor")
        animationframe.fromValue = squareView.layer.backgroundColor
        animationframe.toValue = UIColor.blue.cgColor
        animationframe.duration = 2
        squareView.layer.add(animation, forKey: "colorAnimation")
        
        // CATRANSITION
        let animation1 = CATransition()
        animation1.type = .push
        animation1.duration = 2
        squareView.layer.cornerRadius = squareView.layer.cornerRadius == 50 ? 0 : 50
        squareView.layer.add(animation1, forKey: "transition")
    
        /// UIVIEW ANIMATE
        UIView.animate(
            withDuration: 0.3,
            delay: .zero,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in
                guard let self else { return }
                squareView.frame = .init(origin: squareView.frame.origin, size: .init(
                    width: squareView.frame.width,
                    height: squareView.frame.height
                ))
                squareView.layer.cornerRadius = 50
            },
            completion: { _ in
                print("Анимация закончилась")
            }
        )
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
