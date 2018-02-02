//
//  DeviceTableViewCell.swift
//  today
//
//  Created by Martin Púčik on 02/02/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    static let cellId: String = "DeviceTableViewCell"

    // MARK: - Private Props
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView.init()
        view.image = #imageLiteral(resourceName: "lampOff")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Interface
    func setTitle(title: String) {
        titleLabel.text = title
    }
}

private extension DeviceTableViewCell {
    func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 16)
        ])
    }
}
