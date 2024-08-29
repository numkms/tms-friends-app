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
    
    struct Friend: InfoTableViewCellModel, Equatable {
        var title: String { name }
        var image: UIImage? { avatar }
        
        
        var id: UUID
        let name: String
        let age: Int
        let avatar: UIImage?
        var gallery: [UIImage]
        var canSeeMyPosts: Bool
        var canSeeMyGallery: Bool
        var canSeeMyPageInfo: Bool
        var dateOfBirth: Date?
        var group: String
        
        init(
            id: UUID = .init(),
            name: String,
            age: Int,
            avatar: UIImage? = nil,
            gallery: [UIImage] = [
                UIImage(systemName: "trash")!,
                UIImage(systemName: "figure.walk.diamond.fill")!,
                UIImage(systemName: "airplane.circle")!,
                UIImage(systemName: "bolt.car.circle")!,
                UIImage(systemName: "truck.box.badge.clock")!,
                UIImage(systemName: "fuelpump.fill")!
            ],
            canSeeMyPosts: Bool = true,
            canSeeMyGallery: Bool = true,
            canSeeMyPageInfo: Bool = true,
            dateOfBirth: Date? = nil,
            group: String = ""
        ) {
            self.id = id
            self.name = name
            self.age = age
            self.avatar = avatar
            self.gallery = gallery
            self.canSeeMyPosts = canSeeMyPosts
            self.canSeeMyGallery = canSeeMyGallery
            self.canSeeMyPageInfo = canSeeMyPageInfo
            self.dateOfBirth = dateOfBirth
            self.group = group
        }
        var yearsOldFormatted: String {
            guard let yearsOld else { return "Не указано" }
            return "\(yearsOld) лет"
        }
        
        var yearsOld: Int? {
            let currentDate = Date.now
            guard let dateOfBirth else { return nil }
            let dateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: .now)
            return dateComponents.year
        }
        
        var dateOfBirthFormatted: String? {
            guard let dateOfBirth else { return "" }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .init(identifier: "ru-RU")
            dateFormatter.dateFormat = "d MMM, EEE YYYY года"
            return dateFormatter.string(from: dateOfBirth)
        }
    }
    lazy var photosStackView: UIStackView = .init()
    lazy var tableView: UITableView = .init()
    lazy var userInfoView = UIStackView()
    lazy var nameLabel = UILabel()
    lazy var ageLabel = UILabel()
    lazy var statusLabel = UILabel()
    
    lazy var collectionView = UICollectionView()
    
    lazy var setStatusButton = UIButton(primaryAction: UIAction.init(handler: { _ in
        let editStatusViewController = StatusEditViewController(
            status: self.statusLabel.text) { newStatus in
                self.statusLabel.text = newStatus
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
        
        
        let imageVIew = UIImageView()
        imageVIew.image = .init(named: "Image")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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


