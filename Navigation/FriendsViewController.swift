//
//  FriendsViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 03.07.2024.
//

import UIKit

class FriendsViewController: UIViewController {
    
    lazy var friendsListView = UIStackView()
    lazy var scrollView = UIScrollView()
    
    lazy var scrollToTop = UIButton(primaryAction: .init(handler: { _ in
//        self.scrollView.setContentOffset(.zero, animated: true)
        let yTo = self.friendsListView.arrangedSubviews[20].frame.minY
        let vcHeight = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        let maxY = self.scrollView.contentSize.height - vcHeight
        if yTo < maxY {
            self.scrollView.setContentOffset(.init(x: .zero, y: yTo), animated: true)
        } else {
            self.scrollView.setContentOffset(.init(x: .zero, y: maxY), animated: true)
        }
        
    }))
    
    func buildMenuItemView(
        icon: UIImage,
        title: String,
        action: UIAction
    ) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let iconView = UIImageView(image: icon)
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let actionView = UIButton(primaryAction: action)
        actionView.titleLabel?.widthAnchor.constraint(equalTo: actionView.widthAnchor).isActive = true
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.setTitle(title, for: .normal)
        actionView.configuration?.contentInsets = .zero
        
        let chevron = UIImageView(image: .init(UIImage(systemName: "chevron.right")!))
        chevron.widthAnchor.constraint(equalToConstant: 30).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(actionView)
        stackView.addArrangedSubview(chevron)
        
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(scrollView)
        friendsListView.axis = .vertical
        friendsListView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(friendsListView)
        friendsListView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        friendsListView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        friendsListView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        friendsListView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        friendsListView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        for number in 1...50 {
            friendsListView.addArrangedSubview(buildMenuItemView(icon: .checkmark, title: "Friend #\(number)", action: UIAction(handler: { _ in
                self.goToFriendScreen(numberFriend: number)
            })))
        }
        
        view.addSubview(scrollToTop)
        scrollToTop.translatesAutoresizingMaskIntoConstraints = false
//        scrollToTop.setImage(?.withTintColor(.red), for: .normal)
        scrollToTop.setTitle("TOUCH THIS TO GO UP", for: .normal)
        scrollToTop.titleLabel?.font = .systemFont(ofSize: 30)
        scrollToTop.setTitleColor(.red, for: .normal)
        scrollToTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollToTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollToTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: scrollToTop.frame.height + 10,
            right: .zero
        )
    }
    
    func goToFriendScreen(numberFriend: Int) {
        let friendViewController = FriendViewController(friend: .init(name: "Друг номер \(numberFriend)", age: numberFriend * 2))
        navigationController?.pushViewController(friendViewController, animated: true)
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

extension FriendsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
