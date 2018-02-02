//
//  TodayEmptyView.swift
//  today
//
//  Created by Martin Púčik on 02/02/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit

class TodayEmptyView: UIView {

    lazy var effectsView: UIVisualEffectView = {
        let view = UIVisualEffectView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Saved Devices"
//        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
        setupConstraints()
    }

    // MARK: - Actions
    @objc private func addButtonTapped() {

    }
}

private extension TodayEmptyView {
    func setupLayout() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectsView)
        addSubview(titleLabel)
        addSubview(addButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            effectsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            effectsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            effectsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            effectsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),

            addButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16)
        ])
    }
}
