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
        view.widthAnchor.constraint(equalToConstant: 28).isActive = true
        view.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = UIColor.black
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = UIColor.darkGray
        return label
    }()

    private lazy var onOffButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "lampOn"), for: UIControlState.normal)
        button.backgroundColor = UIColor.green
        button.imageEdgeInsets = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        onOffButton.layer.cornerRadius = (frame.height - 6) / 2
    }

    // MARK: - Interface
    func updateCell(withDevice device: WiFiLamp) {
        titleLabel.text = device.name
        subtitleLabel.text = "\(device.chipId): \(device.localNetworkUrl.absoluteString)"
    }
}

private extension DeviceTableViewCell {
    func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(onOffButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            onOffButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            onOffButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            onOffButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            onOffButton.widthAnchor.constraint(equalTo: onOffButton.heightAnchor, multiplier: 1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}
