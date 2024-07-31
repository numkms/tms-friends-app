//
//  FriendTableViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 15.07.2024.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
    
    let imageIdentifier: String = "imageItem"
    var onImageTap: ((UIImage) -> Void)?
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(collectionView)
        
        // MARK: - Layout
        let spacing: CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        let itemWidth = UIScreen.main.bounds.width / 4
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
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setup(
        images: [UIImage],
        onImageTap: @escaping (UIImage) -> Void
    ) {
        self.images = images
        self.onImageTap = onImageTap
    }
}

extension ImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
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
        onImageTap?(images[indexPath.item])
    }
}

class LabelTableViewCell: UITableViewCell {
    
    lazy var keyLabel: UILabel = .init()
    lazy var valueLabel: UILabel = .init()
    lazy var stackView: UIStackView = .init(arrangedSubviews: [keyLabel, valueLabel])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        keyLabel.text = nil
        valueLabel.text = nil
    }
    
    private func setupCell() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setup(
        key: String,
        value: String
    ) {
        keyLabel.text = key
        valueLabel.text = value
    }
}

class FriendTableViewController: UIViewController {
    
    lazy var tableView = UITableView()
    
    let friend: FriendViewController.Friend
    
    var status: String?
    
    struct Section {
        let title: String
        let cells: [Cell]
    }
    
    struct Cell {
        let cell: ReuseIdentifier
        let labels: (key: String, value: String)?
        let images: [UIImage]?
    }
    
    var sections: [Section] {
        return [
            .init(title: "Личная информация", cells: [
                .init(
                    cell: .label,
                    labels: (key: "Имя", value: friend.name),
                    images: nil
                ),
                .init(
                    cell: .label,
                    labels: (key: "Возраст", value: "\(friend.age)"),
                    images: nil
                ),
                .init(
                    cell: .label,
                    labels: (key: "Статус", value: status ?? ""),
                    images: nil
                ),
            ]),
            .init(title: "Фотоальбом", cells: [
                .init(
                    cell: .images,
                    labels: nil,
                    images: friend.gallery
                )
            ])
        ]
    }
    
    enum ReuseIdentifier: String {
        case label
        case images
    }

    init(friend: FriendViewController.Friend) {
        self.friend = friend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loadingView: LoadingView = LoadingView(frame: .init(
        x: view.center.x - 25,
        y: view.center.y - 25,
        width: 50,
        height: 50
    ))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(loadingView)
        self.loadingView.animationDuration = 0.3
        self.loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setupView()
            self.loadingView.endAnimating()
            self.loadingView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            LabelTableViewCell.self,
            forCellReuseIdentifier: ReuseIdentifier.label.rawValue
        )
        tableView.register(
            ImagesTableViewCell.self,
            forCellReuseIdentifier: ReuseIdentifier.images.rawValue
        )
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
        tableView.delegate = self
        tableView.dataSource = self
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


extension FriendTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        if cellData.labels?.key == "Статус" {
            let statusEditVC = StatusEditViewController(status: status) { newStatus in
                self.status = newStatus
            }
            present(statusEditVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        if cellData.labels?.key == "Статус" {
            return true
        } else {
            return false
        }
    }
}

extension FriendTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        var cell: UITableViewCell?
        
        switch cellData.cell {
        case .images:
            let imagesCell = tableView.dequeueReusableCell(withIdentifier: cellData.cell.rawValue) as? ImagesTableViewCell
             imagesCell?.setup(
                images: cellData.images ?? [],
                onImageTap: { image in
                    let vc = PhotoPreviewViewController(image: image)
                    self.present(vc, animated: true)
                }
             )
             cell = imagesCell
        case .label:
           let labelCell = tableView.dequeueReusableCell(withIdentifier: cellData.cell.rawValue) as? LabelTableViewCell
            labelCell?.setup(
                key: cellData.labels?.key ?? "",
                value: cellData.labels?.value ?? ""
            )
            cell = labelCell
        }
        
        return cell ?? UITableViewCell()
    }
}
