//
//  ToggleSwitchController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 29.07.2024.
//

import UIKit

class ToggleSwitchControl: UIControl {
    private let onImageView = UIImageView()
    private let offImageView = UIImageView()
    private let onImage: String
    private let offImage: String
    
    private var isOn: Bool = false
    private var animationDuration: TimeInterval = 10
    
    override var frame: CGRect {
        set {
            super.frame = newValue
            updatePositions()
        }
        
        get {
            super.frame
        }
    }

    override init(frame: CGRect) {
        self.onImage = "doc.fill"
        self.offImage = "doc"
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.onImage = "doc.fill"
        self.offImage = "doc"
        super.init(coder: coder)
        setupUI()
    }
    
    init(
        frame: CGRect,
        onImage: String = "doc.fill",
        offImage: String = "doc"
    ) {
        self.onImage = onImage
        self.offImage = offImage
        super.init(frame: frame)
        setupUI()
    }
    
    init(
        onImage: String = "doc.fill",
        offImage: String = "doc"
    ) {
        self.onImage = onImage
        self.offImage = offImage
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupImage(imageView: onImageView, systemName: onImage)
        setupImage(imageView: offImageView, systemName: offImage)
        onImageView.isHidden = true
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    private func setupImage(imageView: UIImageView, systemName: String) {
        addSubview(imageView)
        imageView.image = UIImage(systemName: systemName)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
    }
    
    func updatePositions() {
        onImageView.frame = bounds
        offImageView.frame = bounds
    }
    
    @objc func handleTap() {
        self.isOn.toggle()
        stateUpdated()
    }
    
    private func stateUpdated() {
        UIView.animate(withDuration: animationDuration) {
            self.updateUI()
        }
        sendActions(for: .valueChanged)
    }
    
    private func updateUI() {
        onImageView.isHidden = !isOn
        offImageView.isHidden = isOn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePositions()
    }
    
    func set(isOn: Bool) {
        self.isOn = isOn
        stateUpdated()
    }
}
