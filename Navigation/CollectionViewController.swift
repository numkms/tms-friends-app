//
//  CollectionViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 15.07.2024.
//

import UIKit

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

class CollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
    
    lazy var imagesTemplate: [[UIImage?]] = .init(repeating: [
        UIImage(systemName: "trash"),
        UIImage(systemName: "figure.walk.diamond.fill"),
        UIImage(systemName: "airplane.circle"),
        UIImage(systemName: "bolt.car.circle"),
        UIImage(systemName: "truck.box.badge.clock"),
        UIImage(systemName: "fuelpump.fill")
    ], count: 10000)
    
    lazy var images: [UIImage] = imagesTemplate.flatMap { $0 }.compactMap { $0 }
    let imageIdentifier: String = "imageItem"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        // MARK: - Layout
        let itemsInRow: CGFloat = 10
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: imageIdentifier, for: indexPath) as? ImageCollectionViewCell
        cell?.setup(image: images[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PhotoPreviewViewController(image: images[indexPath.item])
        present(viewController, animated: true)
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

