//
//  GestureViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 31.07.2024.
//

import UIKit

class MyTapGestureRecognizer: UITapGestureRecognizer {
    let handler: () -> Void
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(handle))
        print("init")
    }
    
    @objc private func handle() {
        print("handler")
        self.handler()
    }
}

class Square: UIView {
    
    enum Constants {
        static let somethingWidth: CGFloat = 116
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if name == "Overlay" {
            return nil
        }
        print(point)
        print(name)
        if name == "square", super.hitTest(point, with: event) == nil {
            return subviews.first
        }
        return super.hitTest(point, with: event)
    }
}


class CustomView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("CustomView")
        return super.hitTest(point, with: event)
    }
}

class GestureViewController: UIViewController {
    
    lazy var overlaySquare: Square = Square(name: "Overlay")
    lazy var bigSquare: Square = Square(name: "big")
    lazy var squareView: Square = Square(name: "square")
    lazy var tinySquare: Square = Square(name: "tiny")
    lazy var logout: UIButton = .init()
    
    lazy var topFrame = CGRect(origin: .zero, size: .init(
        width: view.bounds.width,
        height: view.bounds.height / 2
    ))
    
    lazy var bottomFrame = CGRect(
        origin: .init(
            x: .zero,
            y: view.bounds.maxY - (view.bounds.height / 2)
        ),
        size: .init(
            width: view.bounds.width,
            height: view.bounds.height / 2
        )
    )
    
    let authService: AuthProtocol
    
    init(
        authService: AuthProtocol
    ) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CustomView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlaySquare.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myRecongizer = MyTapGestureRecognizer {
            print("did tap")
        }
        view.addGestureRecognizer(myRecongizer)
        
        logout.setTitle("Logout", for: .normal)
        logout.setTitleColor(.white, for: .normal)
        logout.addAction(UIAction(handler: { [weak self] _ in
            self?.authService.logout()
        }), for: .touchUpInside)
        
        logout.frame = .init(x: .zero, y: 100, width: 100, height: 50)
        
        bigSquare.frame = .init(x: 0, y: 100, width: 400, height: 400)
        bigSquare.backgroundColor = .yellow
        
        tinySquare.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
        tinySquare.backgroundColor = .gray
        squareView.addSubview(tinySquare)
        
        squareView.frame = .init(x: .zero, y: .zero, width: 100, height: 100)
        squareView.backgroundColor = .red
        view.addSubview(bigSquare)
//        view.addSubview(overlaySquare)
    
        overlaySquare.backgroundColor = .black.withAlphaComponent(0.3)
        
        bigSquare.addSubview(squareView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        squareView.addGestureRecognizer(tapGestureRecognizer)
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewDidLongPressed))
        longTapGestureRecognizer.minimumPressDuration = 2
        squareView.addGestureRecognizer(longTapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(viewDidPinch))
        squareView.addGestureRecognizer(pinchGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDidPan))
        squareView.addGestureRecognizer(panGestureRecognizer)
        
        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(viewDidPan))
        tinySquare.addGestureRecognizer(panGestureRecognizer2)
     
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidLogin),
            name: NSNotification.Name("userDidLogin"),
            object: nil
        )
        
        view.addSubview(logout)
    }
    
    @objc func userDidLogin() {
        bigSquare.frame = .init(origin: .zero, size: bigSquare.frame.size)
    }
    
    @objc func viewDidTapped(_ gesture: UITapGestureRecognizer) {
        previousTranslation = nil
        squareView.backgroundColor = [UIColor.red, UIColor.blue, UIColor.green].randomElement()
    }

    @objc func viewDidPinch(_ gesture: UIPinchGestureRecognizer) {
        previousTranslation = nil
        let minLength: CGFloat = 100
        let maxWidth: CGFloat = UIScreen.main.bounds.width
        let maxHeight: CGFloat = UIScreen.main.bounds.height
        squareView.frame = .init(
            origin: squareView.frame.origin,
            size: .init(
                width: min(max(squareView.frame.size.width * gesture.scale, minLength), maxWidth),
                height: min(max(squareView.frame.size.height * gesture.scale, minLength), maxHeight)
            )
        )
    }
    
    
    
    
    var previousTranslation: CGPoint? = nil
    
    @objc func viewDidPan(_ gesture: UIPanGestureRecognizer) {
        print((gesture.view as? Square)?.name)
        let translation = gesture.translation(in: gesture.view)
        var translationDiff: CGPoint?
        if let previousTranslation {
            translationDiff = .init(
                x: translation.x - previousTranslation.x,
                y: translation.y - previousTranslation.y
            )
        }
        let resultTranslation = translationDiff ?? translation
        previousTranslation = translation
        guard let view = gesture.view else { return }
        view.frame = .init(
            origin: .init(
                x: view.frame.origin.x + resultTranslation.x,
                y: view.frame.origin.y + resultTranslation.y
            ),
            size: view.frame.size
        )
        
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.5) {
                let position = gesture.location(in: self.view)
                view.frame = .init(x: position.x, y: position.y, width: 100, height: 100)
            }
            
        case .ended, .failed, .cancelled:
            previousTranslation = nil
            if view.frame.minY > self.view.frame.midY {
                UIView.animate(withDuration: 0.5) {
                    view.frame = self.bottomFrame
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    view.frame = self.topFrame
                }
            }
        default: break
        }
    }
    
    
    func moveSquare(by location: CGPoint) {
        let length = squareView.frame.width
        var xChange: CGFloat = 0
        var yChange: CGFloat = 0
        if location.x > length / 2 {
            xChange = 10
        }
        if location.x <  length / 2 {
            xChange = -10
        }
        if location.y < length / 2 {
            yChange = -10
        }
        if location.y > length / 2 {
            yChange = 10
        }
        squareView.frame = .init(origin: .init(
            x: squareView.frame.origin.x + xChange,
            y: squareView.frame.origin.y + yChange
        ), size: squareView.frame.size)
    }
    
    @objc func viewDidLongPressed(_ gesture: UILongPressGestureRecognizer) {
        previousTranslation = nil
        
        switch gesture.state {
        case .began:
            squareView.frame = .init(
                origin: squareView.frame.origin,
                size: .init(
                    width: squareView.frame.size.width * 2,
                    height: squareView.frame.size.height * 2
                )
            )
        case .changed:
            moveSquare(by: gesture.location(in: squareView))
        case .ended:
            print("ended")
        case .cancelled:
            print("canceled")
        case .failed:
            print("failed")
        case .possible:
            print("possible")
        @unknown default:
            print("unknown")
        }
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
