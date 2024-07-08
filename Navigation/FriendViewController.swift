//
//  FriendViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 03.07.2024.
//

import UIKit

class FriendViewController: UIViewController, StatusEditViewControllerDelegate {
    
    func statusDidSaved(newStatus: String) {
        self.statusLabel.text = newStatus
    }
    
    struct Friend {
        let name: String
        let age: Int
    }
    
    lazy var userInfoView = UIStackView()
    lazy var nameLabel = UILabel()
    lazy var ageLabel = UILabel()
    lazy var statusLabel = UILabel()
    lazy var setStatusButton = UIButton(primaryAction: UIAction.init(handler: { _ in
        let editStatusViewController = StatusEditViewController(
            status: self.statusLabel.text) { newStatus in
//                self.statusLabel.text = newStatus
            }
        editStatusViewController.delegate = self
        self.present(editStatusViewController, animated: true)
    }))
    
    let friend: Friend
    
    init(friend: Friend) {
        self.friend = friend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusButton.setTitle("Изменить статус", for: .normal)
        setStatusButton.setTitleColor(.blue, for: .normal)
        userInfoView.axis = .vertical
        nameLabel.text = friend.name
        ageLabel.text = "\(friend.age)"
        view.backgroundColor = .white
        view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        userInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        userInfoView.addArrangedSubview(nameLabel)
        userInfoView.addArrangedSubview(ageLabel)
        userInfoView.addArrangedSubview(UIStackView(arrangedSubviews: [
            statusLabel,
            setStatusButton
        ]))
        
        // Do any additional setup after loading the view.
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
