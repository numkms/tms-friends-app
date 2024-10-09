//
//  LaunchTableViewCell.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {
    
    lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titlesStack,
            iconView
        ])
        stack.translatesAutoresizingMaskIntoConstraints  = false
        return stack
    }()
    
    lazy var titlesStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                subtitleLabel
            ]
        )
        stack.axis = .vertical
        return stack
    }()
    
    lazy var iconView: UIImageView = .init()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(horizontalStack)
        contentView.layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(model: ViewModels.Launch) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        iconView.image = model.icon
    }
}
