//
//  GuestViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit
import CoreLocation
import MapKit

class GuestViewController: UIViewController {
    
    enum Constants {
        static var padding: CGFloat = 10
        static var radius: CGFloat = 20
    }
    
    lazy var backgroundImageView = UIImageView()
    lazy var imageView = UIImageView()
    lazy var label = UIButton(configuration: .plain(), primaryAction: UIAction(handler: { _ in
        let rootViewController = FriendsViewController(
            onFriendClick: nil,
            bottomButtonConfig: .init(title: "Ничего не делает", action: {})
        )
        let navigationViewController = UINavigationController(
            rootViewController: rootViewController
        )
        self.present(navigationViewController, animated: true)
    }))
    lazy var wrapper = UIView()
    
    private let locationManager = CLLocationManager()
    
    lazy var mapView: MKMapView = .init()
    var userOverlay: MKCircle?
    lazy var slider: UISlider = .init(frame: .zero)
    
    @objc func sliderChanged() {
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: zoomValue), animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        slider.value = 1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        // MARK: - Add background
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        backgroundImageView.image = .init(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
    
        // MARK: - Set data
        label.setTitle("Welcome to the club, buddy!", for: .normal)
        label.setTitleColor(.white, for: .normal)
        imageView.image = .checkmark
        // MARK: - Configuring views
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.textColor = .white
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidLogin),
            name: NSNotification.Name("userDidLogin"),
            object: nil
        )
        
        view.addSubview(mapView)
        
        mapView.frame = view.bounds
        mapView.delegate = self
        
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    @objc func userDidLogin(_ notification: Notification) {
        print(notification.userInfo)
        guard let userName = notification.userInfo?["userName"] as? String else { return }
        label.setTitle("You are part of the club, \(userName)!", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
//        uservc.willMove(toParent: nil)
//        uservc.view.removeFromSuperview()
//        uservc.removeFromParent()
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


extension GuestViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           var circle = MKCircleRenderer(overlay: overlay)
           circle.strokeColor = UIColor.red
           circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
           circle.lineWidth = 1
           return circle
    }
}

extension GuestViewController: CLLocationManagerDelegate {
    
    var zoomValue: Double {
        Double(slider.value) * 10000
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            mapView.setCenter(coordinate, animated: false)
            print("Zoom value", zoomValue)
            mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: zoomValue), animated: true)
            if let userOverlay { mapView.removeOverlay(userOverlay) }
            userOverlay = .init(center: coordinate, radius: 10)
            if let userOverlay { mapView.addOverlay(userOverlay) }
        }
    }
}
