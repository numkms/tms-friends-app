//
//  LaunchViewController.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 21.10.2024.
//

import UIKit
import Combine

class LaunchViewModel {
    
    struct Screen {
        let title: String
        let gallery: [UIImage]
    }
    
    var screen: PassthroughSubject<Screen, API.ApiError> = .init()
    var imagesStore: [UIImage] = []
    
    let queue = DispatchQueue(label: "com.launches", attributes: .concurrent)
    
    func loadLaunch(flightNumber: Int) {
        API.shared.getLaunch(flightNumber: flightNumber) { result in
            switch result {
            case let .success(launch):
                    DispatchQueue.main.async { [weak self] in
                        self?.updateScreen(launch: launch)
                        DispatchQueue.global(qos: .userInitiated).async {
                            self?.loadImages(
                                launch: launch,
                                urls: launch.links?.flickrImages?.compactMap { URL(string: $0) } ?? []
                            )
                        }
                    }
            case .failure(let failure):
                self.screen.send(completion: .failure(failure))
            }
        }
    }
    
    
    private func updateScreen(
        launch: LaunchModels.Launch
    ) {
        screen.send(.init(
            title: launch.missionName ?? "NAME IS UNKNOWN",
            gallery: imagesStore
        ))
    }
    
    
    private func loadImages(
        launch: LaunchModels.Launch,
        urls: [URL]
    ) {
        urls.forEach {
            guard let data = try? Data(contentsOf: $0), let image = UIImage(data: data) else { return }
            imagesStore.append(image)
            DispatchQueue.main.async { [weak self] in
                self?.updateScreen(launch: launch)
            }
        }
    }
    
}

class LaunchViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
    
    let viewModel: LaunchViewModel
    let launchID: Int
    
    var cancellable: [AnyCancellable] = []
    
    var screen: LaunchViewModel.Screen? {
        didSet {
            label.text = screen?.title
            collectionView.reloadData()
        }
    }
    
    let imageIdentifier: String = "imageIdentifier"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    init(viewModel: LaunchViewModel, launchID: Int) {
        self.viewModel = viewModel
        self.launchID = launchID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        viewModel.screen.sink { [weak self] error in
            let alertVC = UIAlertController(
                title: "Ошибка",
                message: "Что-то пошло не так", preferredStyle: .alert)
            self?.present(alertVC, animated: true)
        } receiveValue: { [weak self] screen in
            self?.screen = screen
        }.store(in: &cancellable)
        
        viewModel.loadLaunch(flightNumber: launchID)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(label)
        
        let itemsInRow: CGFloat = 3
        let spacing: CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let availableWidth = UIScreen.main.bounds.width - (spacing * 5)
        let itemWidth = availableWidth / itemsInRow
        layout.itemSize = .init(
            width: itemWidth,
            height: itemWidth
        )
        collectionView.collectionViewLayout = layout
        
        collectionView.contentInset = .init(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: imageIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .blue
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
}


extension LaunchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screen?.gallery.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: imageIdentifier, for: indexPath) as? ImageCollectionViewCell
        if let image = screen?.gallery[indexPath.item] {
            cell?.setup(image: image)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = screen?.gallery[indexPath.item] {
            let viewController = PhotoPreviewViewController(image: image)
            present(viewController, animated: true)
        }
    }
}



class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = .init()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .gray
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setup(image: UIImage) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoPreviewViewController: UIViewController {
    
    let imageView = UIImageView()
    var image: UIImage
    
    init(
        image: UIImage
    ) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
