//
//  AuthViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 01.07.2024.
//

import UIKit
import SafariServices
import AVFoundation
import AVKit

class AuthViewController: UIViewController {
    enum Constants {
        static var padding: CGFloat = 10
        static var radius: CGFloat = 20
        static var defaultTopWrapperMargin: CGFloat = 60
    }
    
    
    lazy var imageView = UIImageView()
    
    lazy var userNamelabel = UILabel()
    lazy var passwordLabel = UILabel()
    
    lazy var userNameField = UITextField()
    lazy var passwordField = UITextField()
    
    lazy var statusLabel = UILabel()
    
    lazy var loginButton = UIButton()
    lazy var forgetPasswordButton = UIButton()
    lazy var licenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрируясь вы приринмаете публичную оферту", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.addAction(UIAction(handler: {[weak self] _ in
            guard let player = self?.player else { return }
            if player.isPlaying {
                player.stop()
            } else {
                player.play()
            }
            
//            guard let url = URL(string: "http://google.com") else { return }
//            let safariViewController = SFSafariViewController(url: url)
//            safariViewController.delegate = self
//            self.present(safariViewController, animated: true)
        }), for: .touchUpInside)
        return button
    }()
    lazy var wrapper = UIStackView()
    lazy var buttonsStack = UIStackView()
    lazy var backgroundImageView = UIImageView(
        image: .authbackground
    )
    lazy var blurEffect = UIBlurEffect(style: .light)
    lazy var wrapperBlurEffect = UIBlurEffect(style: .prominent)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    lazy var wrapperBlurEffectView = UIVisualEffectView(effect: wrapperBlurEffect)
    lazy var toggleSwitch = ToggleSwitchControl(frame: .init(
        x: view.bounds.width / 2,
        y: 50,
        width: 50,
        height: 50
    ))
    
    lazy var toggleSwitch2 = ToggleSwitchControl(
        frame: .init(
            x: view.bounds.width / 2 + 50,
            y: 50,
            width: 50,
            height: 50
        ),
        onImage: "square.and.arrow.up.fill",
        offImage: "square.and.arrow.up"
    )
    
    lazy var toggleSwitch3 = ToggleSwitchControl(
        onImage: "rectangle.portrait.and.arrow.forward.fill",
        offImage: "rectangle.portrait.and.arrow.forward"
    )

    
    lazy var toggleSwitch4 = ToggleSwitchControl(
        onImage: "pencil.circle.fill",
        offImage: "pencil.circle"
    )
    
    lazy var timer: Timer = .init(timeInterval: 1, repeats: true) { [weak self] _ in
        guard let player = self?.player, player.currentTime > 0 else { return }
        self?.passwordLabel.text = "\(player.duration / player.currentTime)"
    }
    
    func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(blurEffectView)
        
        
        
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        imageView.image = .init(systemName: "person.crop.circle.fill")
        userNamelabel.text = "Username"
        passwordLabel.text = "Password"
        userNameField.placeholder = "Enter your username"
        passwordField.placeholder = "Enter your password"
        loginButton.setTitle("Login", for: .normal)
        forgetPasswordButton.setTitle("Reset password?", for: .normal)
        loginButton.setTitleColor(.blue, for: .normal)
        forgetPasswordButton.setTitleColor(.red, for: .normal)
    }
    
    var wrapperTopConstraint: NSLayoutConstraint?
    
    let authService: AuthProtocol
    let authValidator: AuthValidatorServiceProtocol
    var player: AVAudioPlayer?
    
    init(
        authService: AuthProtocol,
        authValidator: AuthValidatorServiceProtocol
    ) {
        self.authService = authService
        self.authValidator = authValidator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurEffectView.frame = view.bounds
        wrapperBlurEffectView.frame = wrapper.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.addSubview(wrapper)
        
        wrapper.addSubview(wrapperBlurEffectView)
        wrapper.clipsToBounds = true
        
        toggleSwitch3.frame = .init(
            x: view.bounds.width / 2 + 100,
            y: 50,
            width: 50,
            height: 50
        )
        
        toggleSwitch2.set(isOn: true)
        toggleSwitch4.set(isOn: true)
        // MARK: - Configuring views
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .black.withAlphaComponent(0.3)
        wrapper.layer.cornerRadius = Constants.radius
        
        wrapper.axis = .vertical
        wrapper.alignment = .center
        
        wrapper.distribution = .fill
        
        buttonsStack.axis = .horizontal
        
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true
        
        licenseButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // MARK: - Wrapper Stack layout
        
        wrapper.addArrangedSubview(imageView)
        wrapper.addArrangedSubview(userNamelabel)
        wrapper.addArrangedSubview(userNameField)
        wrapper.addArrangedSubview(passwordLabel)
        wrapper.addArrangedSubview(passwordField)
        wrapper.addArrangedSubview(statusLabel)
        wrapper.addArrangedSubview(buttonsStack)
        wrapper.addArrangedSubview(licenseButton)
        wrapper.addArrangedSubview(UIView())
        
        wrapper.setCustomSpacing(20, after: buttonsStack)
        wrapper.setCustomSpacing(20, after: userNameField)
        wrapper.setCustomSpacing(20, after: passwordField)

        // MARK: - Buttons stack layout
        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(forgetPasswordButton)
        buttonsStack.spacing = 30
        buttonsStack.distribution = .fillEqually
        // MARK: - Wrapper position layout
        wrapperTopConstraint = wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultTopWrapperMargin)
        wrapperTopConstraint?.isActive = true
        
        wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        wrapper.heightAnchor.constraint(equalToConstant: 410).isActive = true
        view.setNeedsLayout()
        addActions()
        
        userNameField.delegate = self
        
        userNameField.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(userPasswordDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidOpen),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidClosed),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        guard 
            let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        else { return }
        let url = URL(fileURLWithPath: path)
        player = try? AVAudioPlayer(contentsOf: url)
//        player?.play()
//        timer.fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let path = Bundle.main.path(forResource: "light", ofType: "mp4")
        else { return }
        let videoURL = URL(fileURLWithPath: path)
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @objc func userNameDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let result = authValidator.isValid(login: text)
        if result {
            statusLabel.text = nil
        } else {
            statusLabel.text = "Максимальное количество символов 16"
        }
    }
    
    @objc func userPasswordDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let result = authValidator.isValid(password: text)
        if result {
            statusLabel.text = nil
        } else {
            statusLabel.text = "Минимальное количество символов 10"
        }
    }
    
    func addActions() {
        loginButton.addAction(UIAction.init(handler: { _ in
            self.login()
        }), for: .touchUpInside)
    }
    
    @MainActor
    func showCreateTarget() {
        
        let viewController = CreateTargetViewController()
        clear()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @MainActor
    func error() {
        clear()
        statusLabel.text = "Не правильный логин или пароль"
    }
    
    func login() {
        let login = userNameField.text
        let password = passwordField.text
        Task {
            if let login =  await validate(login ?? "", password ?? "") {
                showCreateTarget()
            } else {
                error()
            }
        }
        print("Task setted")
    }
    
    @objc func keyboardDidOpen(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
             let keyboardRectangle = keyboardFrame.cgRectValue
             let keyboardHeight = keyboardRectangle.height
            print("Клавиатура открылась, ее высота", keyboardHeight)
            wrapperTopConstraint?.constant = Constants.defaultTopWrapperMargin - keyboardHeight
            UIView.animate(withDuration: 0.3, delay: .zero, options: [.curveEaseIn]) { [weak self] in
                self?.view.layoutIfNeeded()
            }
         }
        
    }
    
    @objc func keyboardDidClosed() {
        wrapperTopConstraint?.constant = Constants.defaultTopWrapperMargin
        UIView.animate(withDuration: 0.3, delay: .zero, options: [.curveEaseIn]) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func clear() {
        statusLabel.text = nil
        userNameField.text = nil
        passwordField.text = nil
    }
    
    func validate(_ login: String, _ password: String) async -> String?  { 
        switch await authService.auth(login: login, password: password) {
        case let .success(user):
            return user.name
        case .failure(_):
            return nil
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

extension AuthViewController: AVAudioPlayerDelegate {

}

class MyActivity: UIActivity {
    
    override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    override var activityType: UIActivity.ActivityType? {
        return .mail
    }
    
    override var activityTitle: String? {
        return "Отправить email"
    }
    
    override var activityImage: UIImage? {
        return .checkmark
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    var currentTask: URLSessionDataTask?
        
    override func prepare(withActivityItems activityItems: [Any]) {
        print("нажали на отправить e-mail")
    }
    
}



extension AuthViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print(didLoadSuccessfully)
    }
    
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        print("Ушел в браузер")
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        return [MyActivity()]
    }
}

extension AuthViewController: UITextFieldDelegate {
    // Можем ли мы начать вводить значение в TextField
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        guard let text = textField.text else { return true }
//        return !(text.count >= 3)
//    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        print(
            "Lower bound", range.lowerBound,
            "Upper bound", range.upperBound,
            string
        )

        if range.lowerBound == 0, let string = string.first, !string.isLetter {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        let result = authValidator.isValid(login: text)
        return result
    }
}






protocol ProfileEditDelegate {
    func didChangedField(name: String, value: String)
}

protocol ProfileEditFactory {
    init(delegate: ProfileEditDelegate)
}

protocol ProfileEditViewController {
    var delegate: ProfileEditDelegate? { get set }
    func savedSuccessfuly()
}
protocol ProfileEditInteractor {
    func validate(value: String)
}
protocol ProfileEditPresenter {
    func didInput(value: String)
    func updateView(error: String?)
}


class Profile1ViewController {}
protocol Profile1Interactor {}
protocol Profile1Presenter {}


extension Profile1ViewController: ProfileEditDelegate {
    func didChangedField(name: String, value: String) {
        
    }
}
