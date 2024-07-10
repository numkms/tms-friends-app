//
//  FriendsViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 03.07.2024.
//

import UIKit



class DelayedTask {
    let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func execute(after: TimeInterval) {
        /// Ждем таймер
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            /// Запускаем колбек
            self.callback()
        }
    }
}


protocol FriendsViewControllerDelegate: AnyObject {
    func bottomButtonDidTap()
    func friendButtonDidTap(friendNumber: Int)
    func friendScreenDidAppear()
}

class FriendsViewController: UIViewController {
    
    lazy var friendsListView = UIStackView()
    lazy var scrollView = UIScrollView()
    
    lazy var bottomButton = UIButton(primaryAction: .init(handler: { _ in
        self.onBottomButtonClick()
    }))
    
    struct BottomButtonConfig {
        let title: String
        let action: (() -> Void)?
    }
    
    weak var delegate: FriendsViewControllerDelegate?
    
    let onFriendClick: ((Int) -> Void)?
    let bottomButtonConfig: BottomButtonConfig
    
    init(
        onFriendClick: ((Int) -> Void)? = nil,
        bottomButtonConfig: BottomButtonConfig = .init(
            title: "TOUCH THIS TO GO UP",
            action: nil
        )
    ) {
        self.onFriendClick = onFriendClick
        self.bottomButtonConfig = bottomButtonConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onBottomButtonClick() {
        if let action = bottomButtonConfig.action {
            action()
        } else {
            let yTo = self.friendsListView.arrangedSubviews[20].frame.minY
            let vcHeight = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
            let maxY = self.scrollView.contentSize.height - vcHeight
            if yTo < maxY {
                self.scrollView.setContentOffset(.init(x: .zero, y: yTo), animated: true)
            } else {
                self.scrollView.setContentOffset(.init(x: .zero, y: maxY), animated: true)
            }
        }
        delegate?.bottomButtonDidTap()
    }
    
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
    
    func delay(callback: @escaping () -> Void, seconds: TimeInterval) {
        let waitResponseTask = DelayedTask(callback: callback)
        waitResponseTask.execute(after: seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        delay(callback: { [weak self] in
//            self?.scrollView.setContentOffset(.zero, animated: true)
//            print("Scrollview scrolled to the top ")
//        }, seconds: 10)
//        
//        delay(callback: { [weak self] in
//            guard let self else { return }
//            self.scrollView.setContentOffset(.init(x: .zero, y: self.scrollView.contentSize.height - self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom), animated: true)
//            print("Scrollview scrolled to the end ")
//        }, seconds: 5)
//        delay(callback: { [weak self] in
//            guard let self else { return }
//            self.scrollView.isHidden = false
//            print("Is hiddent set to false")
//        }, seconds: 3)
        
        
//        scrollView.isHidden = true
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
//        let seconds: TimeInterval = 10
//        let delayedTask = DelayedTask {
//            print("I am printed after \(seconds)")
//            self.navigationController?.popViewController(animated: true)
//        }
//        delayedTask.execute(after: seconds)
        
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
        
        view.addSubview(bottomButton)
        
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.setTitle(bottomButtonConfig.title, for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 30)
        bottomButton.setTitleColor(.red, for: .normal)
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.friendScreenDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: bottomButton.frame.height + 10,
            right: .zero
        )
    }
    
    func goToFriendScreen(numberFriend: Int) {
        if let onFriendClick {
            onFriendClick(numberFriend)
        } else {
            let friendViewController = FriendViewController(
                friend: .init(name: "Друг номер \(numberFriend)", age: numberFriend * 2)
            )

            navigationController?.pushViewController(friendViewController, animated: true)
        }
        delegate?.friendButtonDidTap(friendNumber: numberFriend)
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
//        print(scrollView.contentOffset)
    }
}
