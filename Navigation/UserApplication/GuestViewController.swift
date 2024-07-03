//
//  GuestViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit

class GuestViewController: UIViewController {
    enum Constants {
        static var padding: CGFloat = 10
        static var radius: CGFloat = 20
    }
    
    lazy var imageView = UIImageView()
    lazy var label = UILabel()
    lazy var wrapper = UIView()
   

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // MARK: - Set data
        label.text = "Welcome to the club, buddy!"
        imageView.image = .checkmark
        // MARK: - Configuring views
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .black.withAlphaComponent(0.3)
        wrapper.layer.cornerRadius = Constants.radius
        // MARK: - Add subviews
        view.addSubview(wrapper)
        wrapper.addSubview(imageView)
        wrapper.addSubview(label)
        
        // MARK: - Wrapper constraints
        wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // MARK: - Image view constraints
        imageView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: Constants.padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: Constants.padding).isActive  = true
        imageView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -Constants.padding).isActive  = true
        
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // MARK: - Label constraints
        label.topAnchor.constraint(
            equalTo: imageView.bottomAnchor,
            constant: Constants.padding
        ).isActive = true
        label.leadingAnchor.constraint(
            equalTo: wrapper.leadingAnchor,
            constant: Constants.padding
        ).isActive = true
        label.trailingAnchor.constraint(
            equalTo: wrapper.trailingAnchor, 
            constant: -Constants.padding
        ).isActive = true
        label.bottomAnchor.constraint(
            equalTo: wrapper.bottomAnchor,
            constant: -Constants.padding
        ).isActive = true
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
