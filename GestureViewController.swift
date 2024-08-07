//
//  GestureViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 31.07.2024.
//

import UIKit


class Square: UIView {
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
    
    override func loadView() {
        view = CustomView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlaySquare.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bigSquare.frame = .init(x: 0, y: 100, width: 400, height: 400)
        bigSquare.backgroundColor = .yellow
        
        tinySquare.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
        tinySquare.backgroundColor = .gray
        squareView.addSubview(tinySquare)
        
        squareView.frame = .init(x: .zero, y: .zero, width: 100, height: 100)
        squareView.backgroundColor = .red
        view.addSubview(bigSquare)
        view.addSubview(overlaySquare)
    
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
        case .ended, .failed, .cancelled:
            previousTranslation = nil
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
